FROM timberio/vector:0.42.0-debian
RUN rm -f /etc/vector/vector.yaml
COPY my-setup/vector.toml /etc/vector/
COPY my-setup/start.sh .
COPY secret_g_service_account_app_logs_writer.json /service_account_credentials.json
CMD ["bash", "start.sh"]
ENTRYPOINT []
