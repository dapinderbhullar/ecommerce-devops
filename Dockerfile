FROM python:3.11

COPY dataset ./dataset

# Install Java (REQUIRED for Spark)
RUN apt-get update && apt-get install -y default-jdk

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /app

COPY . .

RUN pip install fastapi uvicorn pyspark pandas

CMD ["uvicorn", "backend.app:app", "--host", "0.0.0.0", "--port", "8000"]