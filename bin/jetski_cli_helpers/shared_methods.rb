module JetskiCLIHelpers
  module SharedMethods
    def indent_code(code, level = 1)
      code.strip.split("\n").map { |l| 
        (1..level).map { |lvl| "  " }.join + l }.join("\n")
    end
  end
end