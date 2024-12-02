require "bundler/setup"
require "debug"

input = Pathname.new(__dir__).join("input.txt").readlines

reports = input.map { |l| l.split(/\s+/).map(&:strip).map(&:to_i) }

good_reports_count = reports.count do |report|
  all_diffs = report.each_cons(2).map { |a, b| a - b }

  same_direction = all_diffs.all?(&:positive?) || all_diffs.all?(&:negative?)

  diffs_ok = all_diffs.map(&:abs).none? { |d| d > 3 || d.zero? }

  same_direction && diffs_ok
end

puts good_reports_count
