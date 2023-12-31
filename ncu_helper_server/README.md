# doc

## idk

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
        "account":\$\{user eeclss account\}, \
        "password":\$\{user eeclass password\},\
      }
    - 404: user not found

- get data by line user_id
  - method: GET
  - url\
      \$\{server\}/eeclass_api/get_data?user_id=\$\{line_user_id\}
  - returned status
    - 200:\
      return json\
      {\
        "eeclass_account":\$\{user eeclss account\}, \
        "eeclass_password":\$\{user eeclass password\},\
        "notion_token":\$\{user notion token\}, \
        "notion_template_id":\$\{user notion template id\},\
      }
    - 404: user not found

- get scheduling data
  - method: GET
  - url\
      \$\{server\}/scheduling/api/get_data?user_id=\$\{line_user_id\}
  - returned status
    - 200:\
      return json\
      {\
        "is_auto_update":\$\{is scheduling opened\},\
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

- update scheduling
  - method: POST
  - url\
        \$\{server\}/scheduling/api/update
  - body(all required)
    - user_id: line user_id
    - is_auto_update: whether scheduling is active or not
    - scheduling_time: update interval (minute:int)
  - returned status
    - 200: success
    - 401: fail

- update hsr data
  - method: POST
  - url\
        \$\{server\}/backenddb/HSR/save_data
  - body(all required)
    - user_id: line user_id
    - id_card_number: id card number
    - phone_number: phone number
    - email: email
  - returned status
    - 200: success
    - 401: fail
  
- get scheduling data
  - method: GET
  - url\
      \$\{server\}/backenddb/HSR/get_data?user_id=\$\{line_user_id\}
  - returned status
    - 200:\
      return json\
      {\
        "id_card_number":\$\{user id card number\},\
        "phone_number":\$\{user phone number\},\
        "email":\$\{user email\}\
      }
    - 404: user not found
