namespace: Integration.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.39
    - username: root
    - password:
        default: admin@123
        sensitive: true
    - filename: test.test
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 188
        y: 305
        navigate:
          27b3d5ab-d7a2-6d63-9e61-03e230130616:
            targetId: f2cde643-3e4c-b093-91c9-07c7798277af
            port: SUCCESS
    results:
      SUCCESS:
        f2cde643-3e4c-b093-91c9-07c7798277af:
          x: 282
          y: 196
