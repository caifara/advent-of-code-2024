require "bundler/setup"
require "debug"

def report_good_enough?(raw_report)
  reports = [
    raw_report,
    *raw_report.each_index.map { |i| raw_report.dup.tap { |r| r.delete_at(i) } },
  ]

  reports.each do |report|
    all_diffs = report.each_cons(2).map { |a, b| a - b }

    same_direction = all_diffs.all?(&:positive?) || all_diffs.all?(&:negative?)

    diffs_ok = all_diffs.map(&:abs).none? { |d| d > 3 || d.zero? }

    return true if same_direction && diffs_ok
  end

  false
end

input = Pathname.new(__dir__).join("input.txt").readlines

reports = input.map { |l| l.split(/\s+/).map(&:strip).map(&:to_i) }

good_reports_count = reports.count do |report|
  report_good_enough?(report)
end

puts good_reports_count
