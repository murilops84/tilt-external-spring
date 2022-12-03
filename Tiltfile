load('ext://restart_process', 'docker_build_with_restart')
project_path = '/home/murilo/Projects/my-backend/'

k8s_yaml(kustomize('kustomize'))

local_resource(
  'maven-build',
  'mvn -f {} package'.format(project_path),
  deps=['{}./src'.format(project_path)]
)

local_resource(
  'copy-jar',
  'mkdir -p ./target/jar' +
  ' && cp {}/target/*.jar ./target/jar/application.jar'.format(project_path),
  deps=['{}./src'.format(project_path)],
  resource_deps=['maven-build']
)

local_resource(
  'extract-jar',
  'java -Djarmode=layertools -jar target/jar/application.jar extract --destination ./target/jar/',
  deps=['{}./src'.format(project_path)],
  resource_deps=['copy-jar']
)

docker_build_with_restart(
  'my-backend',
  '.',
  entrypoint=['java',  'org.springframework.boot.loader.JarLauncher'],
  dockerfile='./Dockerfile',
  live_update=[
    sync('./target/jar/dependencies', '/app'),
    sync('./target/jar/snapshot-dependencies', '/app'),
    sync('./target/jar/spring-boot-loader', '/app'),
    sync('./target/jar/application', '/app')
  ])

#docker_build(ref='my-backend', context=project_path)