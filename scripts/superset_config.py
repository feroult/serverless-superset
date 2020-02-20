import os
import random
import string

def randomString(stringLength=10):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))

APP_NAME = "DnA Studio"
SECRET_KEY = '21adf2809644c51a0e166a05b3315f68212b297d'
DATA_DIR = "/tmp/superset-" + randomString(20)

# Mapbox
MAPBOX_API_KEY = os.getenv('MAPBOX_API_KEY', '')

# PostgreSQL
POSTGRES_USER = os.getenv('POSTGRES_USER', '')
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD', '')
POSTGRES_HOST = os.getenv('POSTGRES_HOST', '')
POSTGRES_PORT = os.getenv('POSTGRES_PORT', 5432)
POSTGRES_DB = os.getenv('POSTGRES_DB', '')
SQLALCHEMY_DATABASE_URI = 'postgresql://{0}:{1}@{2}:{3}/{4}'.format(
    POSTGRES_USER,
    POSTGRES_PASSWORD,
    POSTGRES_HOST,
    POSTGRES_PORT,
    POSTGRES_DB,
)
SQLALCHEMY_TRACK_MODIFICATIONS = True

# Redis
REDIS_HOST = os.getenv("REDIS_HOST", "")
REDIS_PORT = os.getenv('REDIS_PORT', 6379)

# Celery
class CeleryConfig:
    BROKER_URL = 'redis://{0}:{1}/0'.format(REDIS_HOST, REDIS_PORT)
    CELERY_IMPORTS = ('superset.sql_lab',)
    CELERY_RESULT_BACKEND = 'redis://{0}:{1}/1'.format(REDIS_HOST, REDIS_PORT)
    CELERY_ANNOTATIONS = {'tasks.add': {'rate_limit': '10/s'}}
    CELERY_TASK_PROTOCOL = 1


CELERY_CONFIG = CeleryConfig
