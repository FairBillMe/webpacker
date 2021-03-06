require "shellwords"
require "webpacker/runner"

module Webpacker
  class WebpackRunner < Webpacker::Runner
    def run
      env = Webpacker::Compiler.env
      $stderr.puts "*"*100
      $stderr.puts `ls #{@node_modules_bin_path}`
      cmd = if node_modules_bin_exist?
        ["#{@node_modules_bin_path}/webpack"]
      else
        ["yarn", "webpack"]
      end

      if ARGV.include?("--debug")
        cmd = [ "node", "--inspect-brk"] + cmd
        ARGV.delete("--debug")
      end

      cmd += ["--config", @webpack_config] + @argv
      $stderr.puts cmd.join(" ")

      Dir.chdir(@app_path) do
        Kernel.exec env, *cmd
      end
    end

    private
      def node_modules_bin_exist?
        File.exist?("#{@node_modules_bin_path}/webpack")
      end
  end
end
