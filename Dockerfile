FROM python:3.8-slim-buster
RUN pip install prometheus_client requests
COPY vmware-task.py /vmware-task.py
EXPOSE 8000
ENTRYPOINT ["python", "/vmware-task.py"]

