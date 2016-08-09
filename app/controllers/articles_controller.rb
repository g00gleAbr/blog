class ArticlesController < ApplicationController
	#Callbacks de llamada al ID y autenticacion
	before_action :authenticate_user!, except: [:show,:index,:edit]
	before_action :set_article, except: [:index,:new,:create]
	before_action :authenticate_editor!, only: [:new,:create,:update]
	before_action :authenticate_admin!, only: [:destroy, :publish]
	#Funcion principal
	def index
		@articles = Article.paginate(page: params[:page],per_page:4).publicados.ultimos
	end
	#Mostrar los articulos
	def show
		@article.update_visits_count
		@comment = Comment.new
	end
	#Crear nuevo articulo
	def new
		@article = Article.new
		@categories = Category.all
	end
	#Editar articulo
	def edit
	end
	#Actualizar articulo
	def update
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
	end
	#Publicar articulo
	def publish
		@article.publish!
		redirect_to @article
	end
	#Crear un nuevo articulo
	def create
		@article = current_user.articles.new(article_params)
		@article.categories = params[:categories]
		if @article.save
			redirect_to @article
		else
			render :new
		end
	end
	#Destruir el articulo
	def destroy
		@article.destroy
		redirect_to articles_path
	end
	#Funciones privadas
	private
		def set_article
			@article = Article.find(params[:id])
		end
		def validate_user
			redirect_to new_user_session_path, notice: "Necesitas iniciar sesión"
		end
		def article_params
			params.require(:article).permit(:title,:body,:cover,:categories)
		end
end