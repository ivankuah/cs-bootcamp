namespace: Integration.demo.aos.sub-flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: 10.0.46.39
    - account_service_host: 10.0.46.39
    - db_host: 10.0.46.39
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integration.demo.aos.sub-flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integration.demo.aos.sub-flows.initialize_artifact:
              - host: '${tomcat_host}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 197
        y: 139
      deploy_tm_wars:
        x: 423
        y: 136
        navigate:
          32487976-34a0-2252-5b82-3913c329e4d4:
            targetId: 38cc5567-571d-00c1-65fb-a72f18637b8e
            port: SUCCESS
    results:
      SUCCESS:
        38cc5567-571d-00c1-65fb-a72f18637b8e:
          x: 622
          y: 147
