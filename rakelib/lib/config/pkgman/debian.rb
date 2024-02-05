# Copyright (c) 2023 M.J.N. Corino, The Netherlands
#
# This software is released under the MIT license.

###
# wxRuby3 buildtools platform pkg manager for Debian type systems
###

module WXRuby3

  module Config

    module Platform

      module PkgManager

        PLATFORM_DEPS = %w[libgtk-3-dev libwebkit2gtk-4.0-dev libgspell-1-dev libunwind-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libcurl4-openssl-dev libsecret-1-dev libnotify-dev]

        class << self

          private

          def do_install(distro, pkgs)
            run_apt(make_install_cmd(pkgs))
          end

          def add_platform_pkgs(pkgs)
            # get architecture
            arch = expand('dpkg --print-architecture').strip
            # find pkgs we need
            PLATFORM_DEPS.inject(pkgs) do |list, pkg|
              list << pkg unless (system("dpkg-query -s \"#{pkg}:#{arch}\" >/dev/null 2>&1") ||
                                    system("dpkg-query -s \"#{pkg}:all\" >/dev/null 2>&1") ||
                                    (expand("dpkg-query -s \"#{pkg}\" 2>/dev/null").strip =~ /Architecture: (#{arch}|all)/))
              list
            end
          end

          def run_apt(cmd)
            run("DEBIAN_FRONTEND=noninteractive apt-get -q -o=Dpkg::Use-Pty=0 #{cmd}")
          end

          def update_pkgs
            run_apt('update')
          end

          def make_install_cmd(pkgs)
            # update cache
            update_pkgs
            # get list of available packages
            apt_cache = `apt-cache pkgnames`.chomp.split("\n").collect { |s| s.strip }
            # remove un-installables
            pkgs = pkgs.select { |pkg| apt_cache.include?(pkg) }
            # create install command
            "install -y #{ pkgs.join(' ') }"
          end

        end

      end

    end

  end

end