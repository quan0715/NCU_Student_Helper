from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.document_loaders import TextLoader, PyPDFLoader
from langchain.text_splitter import  RecursiveCharacterTextSplitter
from langchain.vectorstores import Chroma
from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain
from dotenv import load_dotenv
import os
load_dotenv()
api_key = os.getenv('OPENAI_API_KEY')

