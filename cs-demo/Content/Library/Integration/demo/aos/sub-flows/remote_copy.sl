namespace: Integration.demo.aos.sub-flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.39
    - username: root
    - password:
        default: admin@123
        sensitive: true
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/ws/test.test'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 197
        y: 195
      get_file:
        x: 313
        y: 352
      remote_secure_copy:
        x: 522
        y: 360
        navigate:
          73ea06c1-660f-5e76-d555-45521dcc8b11:
            targetId: fbdbf463-0670-928c-5cfa-8c6e3202b9a8
            port: SUCCESS
    results:
      SUCCESS:
        fbdbf463-0670-928c-5cfa-8c6e3202b9a8:
          x: 433
          y: 193
