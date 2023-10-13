### Run virtual machine
```bash
python -m venv venv
source venv/bi/activate
pip install -r requirements.txt
```

### eeclass api

- get account password by line user_id
  - method: GET
  - url\
      \$\{server\}/eeclass_api/get_account_password?user_id=\$\{line_user_id\}
  - returned status
    - 200:\
      return json\
      {"account":${user eeclss account}, "password":${user eeclass password}} 
    - 404: user not found

- check if the account/password is valid to login eeclass
  - method: POST
  - url\
        \$\{server\}/eeclass_api/check_login
  - body(all required)\
    - user_id: line user_id
    - account: eeclass username
    - password: eeclass password
  - returned status
    - 200: login success
    - 401: login fail