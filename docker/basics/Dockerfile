FROM jupyter/minimal-notebook:python-3.11
USER root

RUN apt-get update && \
    apt-get install -y git && \
    pip install --upgrade pip && \
    pip install poetry 

USER ${NB_UID}

COPY --chown=${NB_UID}:{NB_UID} pyproject.toml pyproject.toml
COPY --chown=${NB_UID}:{NB_UID} poetry.lock poetry.lock

RUN poetry export -o /tmp/requirements.txt --without-hashes

RUN pip install --user --use-deprecated=legacy-resolver -r /tmp/requirements.txt