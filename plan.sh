pkg_name=national-parks
pkg_description="A sample JavaEE Web app deployed in Tomcat8"
pkg_origin=billmeyer
pkg_version=0.1.3
pkg_maintainer="Bill Meyer <bill@chef.io>"
pkg_license=('Apache-2.0')
pkg_source=https://github.com/billmeyer/national-parks/archive/v${pkg_version}.tar.gz
pkg_shasum=56a70d7fc432ad275ba256150bd010ce2581346c848e40ddc0fd0f62c5b17a54
pkg_upstream_url=https://github.com/billmeyer/national-parks
pkg_deps=(core/tomcat8 billmeyer/mongodb)
pkg_build_deps=(core/git core/maven)
pkg_expose=(8080)
pkg_svc_user="root"
pkg_svc_group="root"

do_build() {
  build_line "do_build() ====================================="
  # Maven requires JAVA_HOME to be set, and can be set via:
  export JAVA_HOME=$(hab pkg path core/jdk8)

  mvn package
}

do_install() {
  build_line "do_install() ==================================="

  # The files created during do_build() need to be copied into the
  # tomcat webapps directory.

  local webapps_dir="$(hab pkg path core/tomcat8)/tc/webapps"
  cp target/${pkg_name}.war ${webapps_dir}/
  # Seed data will be loaded into Mongo using our init hook
  cp national-parks.json ${pkg_prefix}
  
  # copy the .war file to the root of the package
  cp target/${pkg_name}.war ${pkg_prefix}
}
