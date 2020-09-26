# ft_server

> *This is a System Administration subject. You will discover **Docker** and you will set up your first web server.*

#### 1. 소개

ft_server 는 시스템 관리 개념을 소개하기 위한 과제이다. *스크립트를 이용해 업무를 자동화*하는 것의 중요성을 깨닫게 될 것이다. 이를 위해 `Docker` 기술을 학습하고 완전한 웹 서버를 설치해본다.

#### 2. 일반 지침사항

- **srcs** 라는 폴더 안에 서버 환경설정을 위한 모든 파일을 위치시켜라.
- **Dockerfile** 은 깃 저장소의 루트에 있어야 한다. 이건 당신의 container를 build할 것이다.
  docer-compose는 사용할 수 없다. (docker-compose : container실행을 간편히 해주는 것 )
- WordPress 웹 사이트에 필요한 모든 파일은 srcs안에 있어야 한다.

#### 3. 필수 사항

- 오직 하나의 Docker container 안에 `Ngnix` 웹 서버를 설치해야 한다.
  이 container의 OS는 `Debian Buster`여야 한다.
- 당신의 웹 서버는 여러 서비스가 연동되어야한다. 여기서 말하는 서비스는 다음을 의미한다 .
  - `Wordpress` 웹사이트
  - `phpMyAdmin`
  - `MySQL` : SQL 데이터베이스는 phpMyAdmin과 워드프레스에서 연동하여 사용이 가능해야 한다.
- 당신의 서버는 `SSL 프로토콜`을 사용해야 한다.
- URL에 따라 정확한 웹사이트로 연결될 수 있도록 처리해야 한다.
- 언제든 해제할 수 있는 `autoindex`가 적용되어야 한다.
- [채점 매뉴얼](https://yeosong1.github.io/ft_server-채점-방법)

<br>

# 선행지식

아래 이미지([출처](https://stitchcoding.tistory.com/2))대로 ft_server 과제를 구현하면 된다. 맨 아래부터 하나씩 개념 공부를 해보자.

![img](https://blog.kakaocdn.net/dn/cjYbCv/btqC4t6LHE2/Wqu39thIjmjhnvnqzh6Ck0/img.jpg)



## 1. 도커 (Docker)

![img](https://blog.kakaocdn.net/dn/b0ydwL/btqC6QmqIwH/0b6xq4gbUchSdcNz3CvWO1/img.png)

### CONTAINERS 란?

- 도커는 **컨테이너 기반의 오픈소스 가상화 플랫폼**이다.

- 기존의 가상화 방식(VM)은 주로 **OS를 가상화**하였지만,  **컨테이너는 하드웨어를 분리하지 않고 하나의 머신 위에서 동작하며 OS 커널도 공유**한다. geust OS를 통해 OS를 복제할 필요가 없어 더 효율적인 관리가 가능한 것이다. 
- 성능에 대한 감이 잘 안잡혀 찾아보니, 하나의 VM도 버거운 노트북에서 수십 개의 컨테이너를 실행시킬 수 있을 정도라고 한다.

### IMAGE 란?

![Docker image](https://subicura.com/assets/article_images/2017-01-19-docker-guide-for-beginners-1/docker-image.png)

- 도커에서 가장 중요한 개념은 컨테이너와 함께 **이미지**라는 개념이다.
- 이미지는 **컨테이너 실행에 필요한 파일과 설정값등을 포함하고 있는 것**으로 상태값을 가지지 않고 변하지 않는다(**Immutable**). 
- 컨테이너는 이미지를 실행한 상태라고 볼 수 있고 추가되거나 변하는 값은 컨테이너에 저장된다. 같은 이미지에서 여러 개의 컨테이너를 생성할 수 있고 컨테이너의 상태가 바뀌거나 컨테이너가 삭제되더라도 이미지는 변하지 않고 그대로 남아있다.
- 말그대로 이미지는 컨테이너를 실행하기 위한 모든 정보를 가지고 있기 때문에 더 이상 의존성 파일을 컴파일하고 이것저것 설치할 필요가 없게 된다. 이제 새로운 서버가 추가되면 미리 만들어 놓은 이미지를 다운받고 컨테이너를 생성만 하면 되는 것이다.

### Docker Hub 란?

- 도커 이미지의 용량은 보통 수백 메가로 수 기가가 넘는 경우도 흔하다. 이렇게 큰 용량의 이미지를 서버에 저장하고 관리하는 것은 쉽지 않은데 도커는 **Docker hub**를 통해 공개 이미지를 무료로 관리해 줍니다. 

- [Docker hub](https://hub.docker.com)에서 공개된 이미지를 다운받아 사용하거나, [Docker Registry](https://docs.docker.com/registry/) 저장소를 직접 만들어 관리할 수 있다. 
- 현재 공개된 도커 이미지는 50만개가 넘고 Docker hub의 이미지 다운로드 수는 80억회에 이른다고 한다. 누구나 쉽게 이미지를 만들고 배포할 수 있습니다. 이 모든게 무료.

### Dockerfile 이란?

- 도커는 기본적으로 이미지가 있어야 컨테이너를 생성하고 동작시킬 수 있다. `dockerfile`은 필요한 패키지를 설치하고 동작하기 위한 자신만의 설정을 담은 파일이고, 이 파일로 **이미지를 생성(빌드)**한다. (Makefile과 비슷)

- `dockerfile`은 도커 명령어를 순서에 따라 빌드하며, `dockerfile`을 빌드할 때(이미지 파일로 변환 시킬 때)는 **layer 구조**를 보인다. 이미지가 계층적으로 하나씩 쌓이면서 생성되는 것이다. 

##### Dockerfile 작성예시 및 명령어

```dockerfile
FROM    debian:buster

LABEL   maintainer="daelee@student.42seoul.kr"

RUN    	apt-get update && apt-get install -y \
    	nginx \
    	mariadb-server \
    	php-fpm \
    	php-mysql \
    	php-cli \
    	php-mbstring \
    	openssl \
    	vim

COPY    srcs/nginx.conf /etc/nginx/sites-available/localhost
COPY    srcs/config.inc.php /var
COPY    srcs/wp-config.php /var
COPY    srcs/phpMyAdmin-4.9.0.1.tar.gz ./
COPY    srcs/wordpress-5.4.1.tar.gz ./
COPY    srcs/init.sh ./
COPY    srcs/theme.tar.gz ./

EXPOSE  80 443

CMD    	bash init.sh
```

- ##### FROM

  - 유효한 Docker 파일은 FROM 명령으로 시작해야 한다.
  - 새 작업을 시작할 베이스 이미지를 지정한다. 
  - 우리 과제에서는 `debian:buster`로 설정.

- ##### LABEL

  - 이미지에 메타데이터를 추가한다.

    - 이미지의 버전 정보, 작성자, 코멘트와 같이 이미지 상세 정보를 작성해두기 위한 명령.

  - 아래 명령어로 이미지의 메타데이터를 확인할 수 있다.

    ```bash
    docker image inspect --format="{{ .Config.Lables }}" [이미지명]
    ```

- ##### RUN

  -  **새 이미지 레이어를 만들어 내** 명령을 실행하고 결과를 커밋한다.
  -  백슬래시(`\`)를 사용하여 다음 줄에 RUN 명령을 계속할 수 있다.
  -  *주의* : 항상  `apt-get update` 와 `apt-get install`는 같은 RUN 실행줄에서 동시에 실행해 캐싱 문제를 방지. (같은 결과를 가져오더라도 RUN을 여러줄로 작성하면 image layer가 여러개 생성되고, RUN을 한줄로 작성하면 image layer가 하나 생성된다.)

- ##### COPY

  - 호스트OS의 파일 또는 디렉토리를 컨테이너 안의 경로로 복사한다.

- ##### EXPOSE

  - 해당 컨테이너가 런타임에 지정된 네트워크 포트에서 수신 대기중 이라는것을 알려준다.

  - 일반적으로 dockerfile을 작성하는 사람과 컨테이너를 직접 실행할 사람 사이에서 공개할 포트를 알려주기 위해 문서 유형으로 작성할 때 사용한다.

  - 이 명령 자체가 작성된 포트를 실행하여 listening 상태로 올려주거나 하지는 않기 때문에, 실제로 포트를 열기 위해선 container run 에서 -p 옵션을 사용해야 한다.

    ```bash
    docker run -p 80:80/tcp -p 80:80/udp ...
    ```

  - 프로토콜을 지정하지 않으면 기본값은 TCP.

- ##### CMD

  - 생성된 컨테이너를 실행할 명령어를 지정한다.
  - 도커 파일에 CMD가 두 개 이상 있는 경우 마지막 CMD만 유효하다.


<br>


## 2. 데비안 (Devian)

`데비안`은 우분투 같은 리눅스 OS 종류 중에 하나다. 우분투처럼 APT를 패키지 및 소프트웨어 관리자로 사용하고 있다. 사실 우분투는 데비안에서 나온 운영체제이며, 우분투에서 볼 수 있는 대부분의 핵심 유틸리티는 데비안에서 나왔다.

데비안은 **안정성을 매우 중시하는 리눅스 배포판**이다. 때문에 안정성을 가장 큰 가치로 두어야 할 서버 쪽에서 상당한 인기를 끌고 있다. 

2019년 7월 6일 배포된 최신 안정 버전은 **10.0(Buster)** 이다.

- [공식 홈페이지](https://www.debian.org/index.ko.html)

<br>



## 3. Nginx

![Google Search Trends: Nginx vs Apache](https://kinsta.com/wp-content/uploads/2019/06/Google-Search-Trends-Apache-vs-Nginx-1.png)

`엔진엑스`는 무료로 제공되는 오픈소스 웹 서버 프로그램이다. 간단하게 **웹 서버는 클라이언트로 부터 요청이 발생했을 때 요청에 맞는 정적콘텐츠을 보내주는 역할**을 한다. `Nginx`는 규모가 작은 서비스이면서 정적 데이터 처리가 많은 서비스에 적합하다고 한다. 

### 웹 서버가 하는 일

![image-20200925160255258](https://user-images.githubusercontent.com/37580034/94279564-40bcbc00-ff87-11ea-9dd3-8276bcd302d1.png)

1. 커넥션을 맺는다 *(클라이언트의 접속을 받아들이거나, 원치 않는 클라이언트라면 닫는다)*
2. 요청을 받는다 *(HTTP 요청 메세지를 네트워크로부터 읽어들인다)* 
3. 요청을 처리한다 *(요청 메세지를 해석하고 행동을 취한다)* 
4. 리소스에 접근한다 *(메세지에서 지정한 리소스에 접근한다)*
5. 응답을 만든다 *(올바른 헤더를 포함한 HTTP 응답 메세지를 생성한다)* 
6. 응답을 보낸다 *(응답을 클라이언트에게 돌려준다)* 
7. 트랜잭션을 로그로 남긴다 *(로그파일에 트랜잭션 완료에 대한 기록을 남긴다)* 

#### 프락시 (Proxy)

- Nginx는 일반적인 HTTP의 웹서버의 역할 외에도 **proxy**, **reverse proxy(대리 프락시) 서버**의 역할 또한 가능하다. 

- 웹 프락시 서버는 클라이언트와 서버 사이에서 트랜잭션을 수행하는 중개인이며, 같은 프로토콜을 사용하는 둘 이상의 애플리케이션을 연결한다.

  ![img](https://camo.githubusercontent.com/33ee2c7e4da4720e5b7e48e2f9fe025a1cc34f45/68747470733a2f2f696d616765732e76656c6f672e696f2f696d616765732f6a65686a6f6e672f706f73742f30343939353063642d666137662d346430362d613434652d6261363737376165666665392f696d6167652e706e67)

- 프락시는 보안을 개선하고, 성능을 높여주며, 비용을 절약한다. 그리고 프락시 서버는 모든 HTTP 트래픽을 감시하고 수정할 수 있다. 프락시는 아래와 같은 일을 한다.

  - 어린이 필터
  - 문서 접근 제어자
  - 보안 방화벽 
  - 웹 캐시

- ##### 대리 프락시 (reverse proxy) 란?

  대리 프락시는 웹 서버인 것처럼 위장해 클라이언트의 요청을 받지만 웹 서버와는 달리 요청 받은 콘텐츠의 위치를 찾아내기 위해 다른 서버와 커뮤니케이션을 시작한다. 대리 프락시는 공용 콘텐츠에 대한 느린 웹 서버의 성능을 개선하기 위해 사용될 수 있다. 이런 식으로 사용되는 대리 프락시를 흔히 서버 가속기라고 부른다. 

<br>



## 4. phpMyAdmin

php를 기반으로 생성된 **mySQL의 GUI**로서 웹에서 실행할 수 있는 프로그램이다. 

- 데비안에 phpmyadmin을 바로 다운로드 할 수 있게하는 패키지는 현재 없다.

- [공식 홈페이지](https://www.phpmyadmin.net)


<br>
# 시작하기

#### 1. 도커 설치 및 시작, 주요 명령어 확인

- [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)에서 `Stable` 버전 설치

- 설치가 완료되면 상단바에 고래 아이콘 등장한다. 도커가 실행중이라는 의미, 즉 터미널에서 도커 접근 가능.

- [도커 명령어 모음](https://yeosong1.github.io/도커-명령어-모음)

  - 컨테이너 조회 (실행 중, 중지된 것까지 포함)

    ```bash
    docker ps -a
    ```

  - 컨테이너 중지 

    ```bash
    docker stop <컨테이너 이름 혹은 아이디>
    ```

  - 컨테이너 시작 (중지 된 컨테이너 시작) 및 재시작 (실행 중인 컨테이너 재부팅)

    ```bash
    docker start <컨테이너 이름 혹은 아이디>
    docker restart <컨테이너 이름 혹은 아이디>
    ```

  - 컨테이너 접속 (실행중인 컨테이너에 접속)

    ```bash
    docker attach <컨테이너 이름 혹은 아이디>
    ```

    

#### 2. 도커로 데비안 버스터 이미지 생성

```sh
docker pull debian:buster 
```

확인하려면 `docker images` 

![image-20200925171325218](https://user-images.githubusercontent.com/37580034/94279988-d8baa580-ff87-11ea-89c0-8d77c0f96ee9.png)



#### 3. 도커로 데비안 버스터 환경 실행 및 접속

```bash
docker run -it --name con_debian -p 80:80 -p 443:443 debian:buster
```

- `-i`옵션은 interactive(입출력), `-t` 옵션은 tty(터미널) 활성화
  -  일반적으로 터미널 사용하는 것처럼 컨테이너 환경을 만들어주는 옵션
- `--name [컨테이너 이름]` 옵션을 통해 컨테이너 이름을 지정할 수 있다. 안하면 랜덤으로 생성? 
- `-p 호스트포트번호:컨테이너포트번호` 옵션은 컨테이너의 포트를 개방한 뒤 호스트 포트와 연결한다.
  - 컨테이너 포트와 호스트 포트에 대한 개념이 궁금하다면 [여기](https://blog.naver.com/alice_k106/220278762795) 참고.
- `buster`를 명시하지 않아도 자동으로 최신 버전을 불러온다.

터미널 창이 아래처럼 바뀌면 데비안 bash에 **접속**한 것이다. 

![image-20200925194314667](https://user-images.githubusercontent.com/37580034/94279991-d8baa580-ff87-11ea-847b-e0eccc81b7a3.png)

종료하고 싶다면 `exit`. 종료한다고 컨테이너가 중지되는 것은 아니다. 컨테이너는 실행 중인 상태에서 접속만 끊은 것이라고 생각하면 된다. 다시 접속하고 싶다면 attach 명령어 사용.



#### 4. 데비안 버스터에 Nginx, cURL 설치

```bash
apt-get -y install nginx curl
```

- 데비안에서는 패키지 매니저로 `apt-get`을 사용한다.
  - 뭔가 설치가 잘 안되면 `apt-get update`, `apt-get upgrade` 순서대로 진행하고 다시 설치.
- `cURL`은 서버와 통신할 수 있는 커맨드 명령어 툴이다. **url을 가지고 할 수 있는 것들은 다할 수 있다.** 예를 들면, http 프로토콜을 이용해 웹 페이지의 소스를 가져온다거나 파일을 다운받을 수 있다. ftp 프로토콜을 이용해서는 파일을 받을 수 있을 뿐 아니라 올릴 수도 있다. 
  - 자세한 curl 사용법과 옵션은 [여기](https://shutcoding.tistory.com/23) 참고.



#### 5. Nginx 서버 구동 및 확인

- nginx 서버 실행

  ```bash
  service nginx start
  ```

- nginx 상태 확인

  ```bash
  service nginx status
  ```

  `[ ok ] nginx is running.` 가 뜨면 서버가 잘 돌아가고 있다는 뜻이다.

  localhost:80 에 접속해보면 서버와의 성공적인 첫 소통을 확인할 수 있다.

  ![image-20200925200151973](https://user-images.githubusercontent.com/37580034/94279993-d9533c00-ff87-11ea-9aca-e12eb2a37632.png)

  같은 내용을 터미널을 통해서도 확인할 수 있다. 아까 다운받은 curl 을 사용한 방식이다.

  ```bash
  curl localhost
  ```

  ![image-20200925200318037](https://user-images.githubusercontent.com/37580034/94279995-d9ebd280-ff87-11ea-84b7-17390b509ef1.png)

- nginx 중지

  ```bash
  service nginx stop 
  ```

  

#### 6. self-signed SSL 인증서 생성

- HTTPS(Hypertext Transfer Protocol over Secure Socket Layer)는 `SSL`위에서 돌아가는 HTTP의 평문 전송 대신에 **암호화된 통신을 하는 프로토콜**이다. 

- 이런 HTTPS를 통신을 서버에서 구현하기 위해서는 *신뢰할 수 있는 상위 기업*이 발급한 인증서가 필요로 한데 이런 발급 기관을 **CA(Certificate authority)**라고 한다. CA의 인증서를 발급받는것은 당연 무료가 아니다. 
- self-signed SSL 인증서는 **자체적으로 발급받은 인증서이며, 로그인 및 기타 개인 계정 인증 정보를 암호화**한다. 당연히 브라우저는 신뢰할 수 없다고 판단해 접속시 보안 경고가 발생한다.
- self-signed SSL 인증서를 만드는 방법은 몇 가지가 있는데, 무료 오픈소스인 `openssl` 을 이용해 쉽게 만들수 있다. 
  - HTTPS를 위해 필요한 `개인키(.key)`, `서면요청파일(.csr)`, `인증서파일(.crt)`을 openssl이 발급해준다.

##### openssl 설치

```bash
apt-get -y install openssl
```

##### 개인키 및 인증서 생성

```bash
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
```

localhost.dev.key 와 localhost.dev.crt가 생성된다. 옵션들을 하나하나 확인해보면,

- req : 인증서 요청 및 인증서 생성 유틸.
- -newkey : 개인키를 생성하기 위한 옵션.
- -keyout <키 파일 이름> : 키 파일 이름을 지정해 키 파일 생성.
- -out <인증서 이름> : 인증서 이름을 지정해 인증서 생성.
- days 365 : 인증서의 유효기간을 작성하는 옵션.

##### 권한제한

```bash
mv localhost.dev.crt etc/ssl/certs/
mv localhost.dev.key etc/ssl/private/
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key
```



#### 7. Nginx에 ssl 설정

- `etc/nginx/sites-available/default` 파일을 수정해줄건데, 좀 더 편한 접근을 위해 vim을 설치해준다.

  ```bash
  apt-get -y install vim
  vim etc/nginx/sites-available/default
  ```

- `default` 파일에 https 연결을 위한 설정을 작성한다.

  원래는 서버 블록이 하나이며 80번 포트만 수신대기 상태인데, https 연결을 위래 443 포트를 수신대기하고 있는 서버 블록을 추가로 작성해야 한다.

  ```nginx
  server {
  	listen 80;
  	listen [::]:80;
  
  	return 301 https://$host$request_uri;
  }
  
  server {
  	listen 443 ssl;
  	listen [::]:442 ssl;
  
  	# ssl 설정
  	ssl on;
  	ssl_certificate /etc/ssl/certs/localhost.dev.crt;
  	ssl_certificate_key /etc/ssl/private/localhost.dev.key;
  
  	# 서버의 root디렉토리 설정
  	root /var/www/html;
  
  	# 읽을 파일 목록
  	index index.html index.htm index.nginx-debian.html;
  
  	server_name ft_server;
  	location / {
  		try_files $uri $uri/ =404;
  	}
  }
  ```

  - 80번 포트로 수신되면 443 포트로 리다이렉션 시켜준다.
  - 443 포트를 위한 서버 블록에는 ssl on 과 인증서의 경로를 작성해준다. 나머지는 기존에 있던 설정 그대로.

- 바뀐 설정을 nginx에 적용한다

  ```bash
  service nginx reload
  ```

- 브라우저에서 https://localhost 로 접속했을 때 경고문구가 뜨면 성공.

  ![image](https://user-images.githubusercontent.com/37580034/94280152-09024400-ff88-11ea-9395-83f9ed440a30.png)

  mac의 chrome에서는  ‘고급’ 설정을 통해서 안전하지 않은 사이트임을 인지하고 접속하는 버튼이 없다.

  ##### 임시 조치 (꼭 신뢰하는 사이트에서만 사용할 것)

  1. NET::ERR_CERT_REVOKED 화면의 빈 공간의 아무 곳에서 마우스 좌클릭.
  2. 키보드로 `thisisunsafe` 문자열 입력. (화면에 보이지 않으니 그냥 입력)
  3. 접속하고자 하는 화면이 보이면 성공. 보이지 않으면 화면 Refresh 하시고 다시 시도.
