BLOG=blog.arteev.net
BUCKETS_PATH=${HOME}/buckets/${BLOG}
S3_PWD=${HOME}/.passwd-s3fs
S3_URL=http://storage.yandexcloud.net 

all: build

build:	
	hugo

prepare-deploy:
	mkdir -p ${BUCKETS_PATH} || true
	chmod 600 ${S3_PWD}	
	s3fs ${BLOG} ${BUCKETS_PATH} -o passwd_file=${S3_PWD} -o url=${S3_URL} -o use_path_request_style

deploy: build	
	cp -f -r public/** ${BUCKETS_PATH}
	
run:
	hugo server -D

.PHONY: clean

clean:
	$(RM) -fr ./public