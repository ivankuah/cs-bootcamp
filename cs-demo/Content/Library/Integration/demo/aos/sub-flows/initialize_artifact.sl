namespace: Integration.demo.aos.sub-flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.39
    - username: root
    - password:
        default: admin@123
        sensitive: true
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/ws/test.test'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integration.demo.aos.sub-flows.remote_copy: []
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integration.demo.aos.sub-flows.remote_copy: []
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code: command_return_code
        navigate:
          - SUCCESS: delete_scripts
          - FAILURE: delete_scripts
    - delete_scripts:
        do:
          Integration.demo.aos.tools.delete_file: []
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_true
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 296
        y: 47
      copy_artifact:
        x: 123
        y: 226
      copy_script:
        x: 369
        y: 237
      execute_script:
        x: 176
        y: 426
      delete_scripts:
        x: 366
        y: 424
      is_true:
        x: 571
        y: 420
        navigate:
          3174c43e-d0d3-bfce-bf69-1c95f771f8f6:
            targetId: da49df77-668d-5bf7-1933-49fc1a84b567
            port: 'TRUE'
          fe23b573-cb63-ed86-b33d-985a7820f453:
            targetId: f4341903-df47-e2ca-71cb-194cc8939051
            port: 'FALSE'
    results:
      FAILURE:
        da49df77-668d-5bf7-1933-49fc1a84b567:
          x: 704
          y: 551
      SUCCESS:
        f4341903-df47-e2ca-71cb-194cc8939051:
          x: 710
          y: 344
