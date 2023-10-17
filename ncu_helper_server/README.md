### Run virtual machine
```bash
python -m venv venv
source venv/bi/activate
pip install -r requirements.txt
```

### line api

- get account password by line user_id
  - method: GET
  - url\
      \$\{server\}/eeclass_api/get_account_password?user_id=\$\{line_user_id\}
  - returned status
    - 200:\
      return json\
      {\
        "eeclass_account":\$\{user eeclss account\}, \
        "eeclass_password":\$\{user eeclass password\},\
        "notion_token":\$\{user notion token\}, \
        "notion_template_id":\$\{user notion template id\}, \
        "is_auto_update":\$\{is scheduling opened\}, \
        "scheduling_time":\$\{user scheduling time\}\
      } 
    - 404: user not found

- check if the eeclass account/password is valid to login eeclass
  - method: POST
  - url\
        \$\{server\}/eeclass_api/check_login
  - body(all required)
    - user_id: line user_id
    - account: eeclass username
    - password: eeclass password
  - returned status
    - 200: login success
    - 401: login fail