# https://luis-sena.medium.com/creating-the-perfect-python-dockerfile-51bdec41f1c8
FROM python:3.7
WORKDIR /app
COPY requirements.txt  ./requirements.txt
RUN pip install -r requirements.txt
EXPOSE 8501
COPY __init__.py __init__.py
ENTRYPOINT ["streamlit", "run"]
CMD ["__init__.py"]