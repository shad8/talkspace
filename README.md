# talkspace
Api for simple forum applications

## Prepare data
Application need to add alias to host file:
```
127.0.0.1 localhost api.example.com
```
```
rake db:create
rake db:migrate
rake db:seed
```
## Api examples:
### User
1. LIST OF USERS
```sh
$ curl -X GET -H "Accept: application/vnd.api.v1+json" -H "Content-Type: application/json" http://api.example.com:3000/users
```
```
{
  "users":[
    {"id":1,"login":"admin","email":"admin@example.com"},
    {"id":2,"login":"user","email":"user@example.com"},
    {"id":3,"login":"john","email":"john@example.com"},
  ]
}
```
2. CREATE USER
```sh
$ curl -v -H "Accept: application/vnd.api.v1+json" -H "Content-type: application/json" -X POST -d ' {"user":{"login":"Tom","password":"qwerty","email":"tom@email.com"}}' http://api.example.com:3000/users
```
```
{
  "user": {
    "id":4,
    "login":"Tom",
    "email":"tom@email.com",
    "token":"26269cb2554d3dc833e274bcd947c3c296183022230ebc6fa020e750d42f76da8e3a277e1134f25deddeee423e7f3e8f3c342c2d68cc50ac00d90e6892a2d22b"
  }
}
```
3. GET USER
```sh
$ curl -X GET -H "Accept: application/vnd.api.v1+json" -H "Content-Type: application/json" http://api.example.com:3000/users/1
```
```
{
  "user": {
   "id":1,"login":"admin","email":"admin@example.com"
  }
}
```
4. DESTROY USER
```sh
$ curl -X DELETE -H "Accept: application/vnd.api.v1+json" -H "Content-Type: application/json" -H "Authorization: Token token=\"b02ce1957fc69a73b3e007ce17563471c8e2de6af12ed6105397dde2c182fc6cb596e7d0b985f63aa0cce4c3d09b95579fceaf937ca24dbead0f348045e64d3a\"" http://api.example.com:3000/users/3
```
### Category
1. LIST OF CATEGORIES
```sh
$ curl -X GET -H "Accept: application/vnd.api.v1+json" -H "Content-Type: application/json" http://api.example.com:3000/categories
```
```
{
  "categories":[
    {"id":1,"name":"Lorem ipsum","user_id":1},
    {"id":2,"name":"IT","user_id":1},
    {"id":3,"name":"Art","user_id":3}
  ]
}
```
2. CREATE CATEGORY
```sh
$ curl -v -H "Accept: application/vnd.api.v1+json" -H "Content-type: application/json" -H "Authorization: Token token=\"964511a3b2755c8a9724fd616fef0480a06704ce307e51484303c9021d72d96adaad464c40cc198f393cffa961f23c8a9c41b878d96eef40ccac9da542c62179\"" -X POST -d ' {"category":{"name":"Ruby on rails","user_id":1}}' http://api.example.com:3000/categories
```
```
{
  "category":{
    "id":4,
    "name":"Ruby on rails",
    "user_id":1
  }
}
```
3. GET CATEGORY
```sh
$ curl -X GET -H "Accept: application/vnd.api.v1+json" -H "Content-Type: application/json" http://api.example.com:3000/categories/1
```
```
{
  "category":{
    "id":1,
    "name":"Lorem ipsum",
    "user_id":1,
    "post_ids":[1]
  },
  "users":[
    {"id":3,"login":"john","email":"john@example.com"}
  ],
  "posts":[
    {"id":1,"title":"Lorem ipsum","body":"Lorem ipsum dolor sit amet, consectetur.","user_id":3}
  ]
}
```
### Post
1. GET POSTS
```sh
$ curl -X GET -H "Accept: application/vnd.api.v1+json" -H "Content-Type: application/json" http://api.example.com:3000/posts/1
```
```
{
  "post":{
    "id":1,
    "title":"Lorem ipsum",
    "body":"Lorem ipsum dolor sit amet, consectetur.",
    "user_id":3
  },
  "users":[
    {"id":3,"login":"john","email":"john@example.com"}
  ]
}
```


