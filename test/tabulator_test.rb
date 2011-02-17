#!/usr/bin/ruby

# OSDV Tabulator - TTV Tabulator Unit Tests
# Author: Jeff Cook
# Date: 2/2/2011
#
# License Version: OSDV Public License 1.2
#
# The contents of this file are subject to the OSDV Public License
# Version 1.2 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://www.osdv.org/license/
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
# License for the specific language governing rights and limitations
# under the License.

# The Original Code is: TTV Tabulator
# The Initial Developer of the Original Code is Open Source Digital Voting Foundation.
# Portions created by Open Source Digital Voting Foundation are Copyright (C) 2010, 2011.
# All Rights Reserved.

# Contributors: Jeff Cook

require "yaml"
require "test/unit"
require "lib/check_syntax_yaml"
require "lib/tabulator"

# The TabulatorTest class provides Unit Testing for the Tabulator class.

class TabulatorTest < Test::Unit::TestCase

  TABULATOR_DATA_FILE = "TABULATOR_DATA.yml"

  JD_ERROR_2 = ["Non-Unique Precinct UID (PRECINCT_1) in Jurisdiction Definition",
                "Non-Unique District UID (DISTRICT_4) in Jurisdiction Definition"]

  JD_WARN_2 = ["Duplicate Precinct Declaration (PRECINCT_2) in Jurisdiction Definition",
                "Duplicate District Declaration (DISTRICT_3) in Jurisdiction Definition"]

  ED_ERROR_12 =
    ["Non-Existent Jurisdiction UID (JURISDICTION_11) in Election Definition",
     "Non-Unique Contest UID (CONTEST_1) in Election Definition",
     "Non-Existent District UID (DISTRICT_11) in Contest UID (CONTEST_3) in Election Definition",
     "Non-Unique Candidate UID (CANDIDATE_1) in Election Definition",
     "Non-Existent Contest UID (CONTEST_11) for Candidate UID (CANDIDATE_2) in Election Definition",
     "Non-Unique Question UID (QUESTION_1) in Election Definition",
     "Non-Existent District UID (DISTRICT_21) for Question UID (QUESTION_2) in Question",
     "Duplicate Answers (A, B, C, A, C, C) for Question UID (QUESTION_2) in Question",
     "Non-Unique Counter UID (COUNTER_1) in Election Definition",
     "Non-Existent Counter UID (COUNTER_11) in Expected Count",
     "Non-Existent Reporting Group (Bad One) for Counter UID (COUNTER_2) in Expected Count",
     "Non-Existent Precinct UID (PRECINCT_22) for Counter UID (COUNTER_2) in Expected Count"]

  ED_WARN_12_5 =
    ["Duplicate Contest Declaration (CONTEST_2) in Election Definition",
     "Duplicate Candidate Declaration (CANDIDATE_3) in Election Definition",
     "Duplicate Question Declaration (QUESTION_1) in Election Definition",
     "Duplicate Counter Declaration (COUNTER_2) in Election Definition",
     "Duplicate Reporting Group (Absentee) in Election Definition"]

  ED_WARN_2 =
    ["Missing ALL Reporting Groups, None Present in Election Definition",
     "Missing ALL Expected Counts, None Present in Election Definition"]

  ED_WARN_4 =
    ["Duplicate Expected Count (COUNTER_1, Normal, PRECINCT_1) in Election Definition",
     "Missing Counter UIDs (COUNTER_2) from Expected Counts",
     "Missing Reporting Groups (Absentee) from Expected Counts",
     "Missing Precinct UIDs (PRECINCT_2) from Expected Counts"]

  CC1_ERROR_4 =
    ["Non-Existent Counter UID (COUNTER_11) in Counter Count",
     "Non-Existent Precinct UID (PRECINCT_11) for Counter UID (COUNTER_11) in Counter Count",
     "Non-Existent Jurisdiction UID (JURISDICTION_11) for Counter UID (COUNTER_11) in Counter Count",
     "Non-Existent Election UID (ELECTION_11) for Counter UID (COUNTER_11) in Counter Count"]

  CC1_WARN_1 = ["Non-Existent Reporting Group (Unknown) for Counter UID (COUNTER_1) in Counter Count"]

  CC1_WARN_1A = ["Unexpected Counter UID (COUNTER_2) in Counter Count"]

  CC1_WARN_1B = ["Unexpected Reporting Group (Absentee) for Counter UID (COUNTER_1) in Counter Count"]

  CC1_WARN_1C = ["Unexpected Precinct UID (PRECINCT_2) for Counter UID (COUNTER_1) in Counter Count"]

  CC2_ERROR_1 = ["Non-Unique File UID (FILE_1) in Counter Count"]

  CC3_ERROR_13 =
    ["Non-Existent Contest UID (CONTEST_33) in Contest Count",
     "Duplicate Contest UID (CONTEST_1) in Contest Count",
     "Non-Existent Candidate UID (CANDIDATE_44) for Contest UID (CONTEST_2) in Contest Count",
     "Improper Candidate UID (CANDIDATE_1) for Contest UID (CONTEST_2) in Contest Count",
     "Duplicate Candidate UID (CANDIDATE_5) for Contest UID (CONTEST_2) in Contest Count",
     "Missing Candidate UIDs (CANDIDATE_4) for Contest UID (CONTEST_2) in Contest Count",
     "Missing Contest UIDs (CONTEST_3) in Contest Counts",
     "Non-Existent Question UID (QUESTION_11) in Question Count",
     "Duplicate Question UID (QUESTION_2) in Question Count",
     "Duplicate Answer (Foo) for Question UID (QUESTION_4) in Question Count",
     "Improper Answer (Bart) for Question UID (QUESTION_4) in Question Count",
     "Missing Answers (Bar, Doo) for Question UID (QUESTION_4) in Question Count",
     "Missing Question UIDs (QUESTION_1) in Question Counts"]

  CC4_ERROR_1 =
    ["Duplicate Counter Count (COUNTER_2, Normal, PRECINCT_2) Input to Tabulator"]
  CC4_WARN_1 =
    ["Unexpected Counter Count (COUNTER_2, Normal, PRECINCT_2) After Tabulator DONE"]

  ERRHEAD = "** ERROR **"
  WARHEAD = "** WARNING **"
  
# Tests for all possible error and warning messages generated by the Tabulator
# during its data validation process, and also tests for achievement of the
# Tabulator DONE state.

  def test_tabulator
    trace = 300          # In case we need to trace, for debugging these tests
    dir = "data/Tests/Validation"
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED.yml", [], [])
    tabulator_test_load_jd_ed(trace, dir, "JD_ERROR_2.yml", "ED.yml", JD_ERROR_2, JD_WARN_2)
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED_ERROR_12.yml", ED_ERROR_12, ED_WARN_12_5)
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED_WARN_2.yml", [], ED_WARN_2)
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED_WARN_4.yml", [], ED_WARN_4)
    tabulator_test_add_cc(trace, dir, "CC1_WARN_1A.yml", [], CC1_WARN_1A)
    tabulator_test_add_cc(trace, dir, "CC1_WARN_1B.yml", [], CC1_WARN_1B)
    tabulator_test_add_cc(trace, dir, "CC1_WARN_1C.yml", [], CC1_WARN_1C)
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC1_ERROR_4.yml", CC1_ERROR_4, [])
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC1_WARN_1.yml", [], CC1_WARN_1)
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC1.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC2_ERROR_1.yml", CC2_ERROR_1, [])
    tabulator_test_add_cc(trace, dir, "CC2.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC3_ERROR_13.yml", CC3_ERROR_13, [])
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC1.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC2.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC3.yml", [], [], true)
    tabulator_test_add_cc(trace, dir, "CC4_ERROR_1.yml", CC4_ERROR_1, CC4_WARN_1)
  end

  def test_tabulator_default
    trace = 300
    dir = "data/Tests/Default"
    tabulator_test_load_jd_ed(trace, dir, "JD.yml", "ED.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC1.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC2.yml", [], [])
    tabulator_test_add_cc(trace, dir, "CC3.yml", [], [], true)
  end

  def test_tabulator_bedrock
    trace = 300
    dir = "data/Tests/Bedrock"
    tabulator_test_load_jd_ed(trace, dir, "Bedrock_JD.yml", "Bedrock_ED.yml", [], [])
    tabulator_test_add_cc(trace, dir, "Bedrock_CC1.yml", [], [], 4)
  end

  def test_tabulator_dc
    trace = 300
    dir = "data/Tests/DC"
    warns = ["Missing ALL Reporting Groups, None Present in Election Definition",
             "Missing ALL Expected Counts, None Present in Election Definition"]
    tabulator_test_load_jd_ed(trace, dir, "DC_EMGR_JD.yml", "DC_EMGR_ED.yml",
                              [], warns)
  end

  def test_tabulator_va
    trace = 300
    dir = "data/Tests/VA"
    warns = ["Missing ALL Reporting Groups, None Present in Election Definition",
             "Missing ALL Expected Counts, None Present in Election Definition"]
    tabulator_test_load_jd_ed(trace, dir, "VA_EMGR_JD.yml", "VA_EMGR_ED.yml",
                              [], warns)
  end

# Arguments:
# * <i>trace</i>:  (<i>Integer</i>) limits tracing of output for the syntax checker
# * <i>prefix</i>: (<i>String</i>) prefix of the schema file name
# * <i>file</i>:   (<i>String</i>) Tabulator data file name
#
# Returns: <i>Hash</i>
#
# Read a schema from one file (under data/Schemas/) and a datum from another
# file from <i>dir</i>/, and then tests the success of performing a syntax
# check of the datum against the schema.

  private
  def tabulator_test_check_syntax(trace, prefix, dir, file)
    schema_file = "data/Schemas/" + "#{prefix}_schema.yml"
    schema = tabulator_test_read_file(schema_file, "Schema")
    file = "#{dir}/#{file}"
    datum = tabulator_test_read_file(file, "Data")
    csy = CheckSyntaxYaml.new
    assert(csy.check_syntax(schema, datum, true, trace).length == 0,
           "Check Syntax of #{file} FAILED")
    print "Check Syntax of #{file}: OK\n"
    datum
  end

# Arguments:
# * <i>trace</i>:    (<i>Integer</i>) limits tracing of output for the syntax checker
# * <i>jd_file</i>:  (<i>String</i>) name of file holding Jurisdiction Definition
# * <i>ed_file</i>:  (<i>String</i>) name of file holding Election Definition
# * <i>errors</i>:   (<i>Array</i>) of expected error messages
# * <i>warnings</i>: (<i>Array</i>) of expected warning messages
#
# Returns: N/A
#
# Tests the creation of a new Tabulator from a Jurisdiction Definition and an
# Election Definition.  The proper number of <i>errors</i> and <i>warnings</i> should
# appear, and they should match exactly, content-wise.

  def tabulator_test_load_jd_ed(trace, dir, jd_file, ed_file, errors, warnings)
    exit(1) unless errors.is_a?(Array) && warnings.is_a?(Array)
    print "\nGenerating Initial Tabulator Count from Files: #{jd_file} #{ed_file}\n"
    jd = tabulator_test_check_syntax(trace, "jurisdiction_definition", dir, jd_file)
    ed = tabulator_test_check_syntax(trace, "election_definition", dir, ed_file)
    tab = Tabulator.new(jd, ed, TABULATOR_DATA_FILE)
    tc = tab.tabulator_count
    if (tab.validation_errors().length == 0)
      tabulator_test_write_tabulator_file(tc)
    end
    taberrs = tabulator_test_errors(tab.validation_errors(), errors)
    tabwarns = tabulator_test_warnings(tab.validation_warnings(), warnings) 
    if (tab.validation_errors().length == 0)
      print "Initial Tabulator Count"
    else
      print "Initial Tabulator Count REJECTED"
    end
    print " with #{taberrs.to_s} ERRORS and #{tabwarns.to_s} WARNINGS\n"    
    tabulator_print_errors_warnings(tab)
  end

# Arguments:
# * <i>received</i>: (<i>Array</i>) of received Tabulator error messages
# * <i>expected</i>: (<i>Array</i>) of expected error messages
#
# Returns: N/A
#
# Tests to ensure that the <i>received</i> error messages exactly match the
# <i>expected</i> error messages.

  def tabulator_test_errors(received, expected)
    assert(expected.length == received.length,
           tabulator_messages_unsame(received, expected, "Error", ERRHEAD))
    received.each_index do |i|
      assert(received[i] == expected[i],
             "Unexpected Error: #{received[i]}\n" +
             "        Expected: #{expected[i]}")
    end
    expected.length 
  end

# Arguments:
# * <i>received</i>: (<i>Array</i>) of received Tabulator warning messages
# * <i>expected</i>: (<i>Array</i>) of expected warning messages
#
# Returns: N/A
#
# Tests to ensure that the <i>received</i> warning messages exactly match the
# <i>expected</i> warning messages.

  def tabulator_test_warnings(received, expected)
    assert(expected.length == received.length,
           tabulator_messages_unsame(received, expected, "Warning", WARHEAD))
    received.each_index do |i|
      assert(received[i] == expected[i],
             "Unexpected Warning: #{received[i]}\n" +
             "          Expected: #{expected[i]}")
    end
    expected.length 
  end

# Arguments:
# * <i>received</i>: (<i>Array</i>) of received error messages
# * <i>expected</i>: (<i>Array</i>) of expected warning messages
# * <i>label</i>:    (<i>String</i>) either "Errors" or "Warnings"
# * <i>header</i>:   (<i>String</i>) either <tt><b>ERRHEAD</b></tt> or <tt><b>WARHEAD</b></tt>
#
# Returns: <i>String</i>
#
# Called only when the sets of <i>received</i> and <i>expected</i> messages
# are not of the same size.  Collects into and returns a single message
# <i>String</i> consisting of the <i>expected</i> error/warning messages
# followed by those actually <i>received</i>.

  def tabulator_messages_unsame(received, expected, label, header)
    message = "Expected #{expected.length.to_s} Validation #{label}s:\n"
    message += tabulator_messages_generate(expected, header)
    message += "Actually Received #{received.length.to_s}:\n"
    message += tabulator_messages_generate(received, header)
  end
      
# Arguments:
# * <i>messages</i>: (<i>Array</i>) of error/warning messages
# * <i>header</i>: (<i>Array</i>) of error/warning messages
# * <i>printit</i>: (<i>Boolean</i>) whether to print the error/warning messages (optional)
#
# Returns: <i>String</i>
#
# Returns a <i>String</i> containing the concatenation of all of the
# error/warning <i>messages</i>, each preceded by the <i>header</i> and
# followed by a <i>newline</i> character.  If <i>printit</i> is <i>true</i>,
# the <i>messages</i> are printed before being returned.

  def tabulator_messages_generate(messages, header, printit = false)
    message = ""
    messages.each { |text| message += "#{header} #{text}\n"}
    print message if printit
    message
  end

# Arguments:
# * <i>tab</i>: (<i>Tabulator</i>) Tabulator object
#
# Returns: N/A
#
# Prints all error and warning messages currently held by the Tabulator.

  def tabulator_print_errors_warnings(tab)
    unless (tab.validation_errors().length == 0 &&
            tab.validation_warnings().length == 0)
      print "\n" 
      tabulator_messages_generate(tab.validation_errors(), ERRHEAD, true)
      tabulator_messages_generate(tab.validation_warnings(), WARHEAD, true)
    end
  end

# Arguments:
# * <i>trace</i>:    (<i>Integer</i>) limits tracing of output for the syntax checker
# * <i>cc_file</i>:  (<i>String</i>) name of file holding Counter Count
# * <i>errors</i>:   (<i>Array</i>) of expected error messages
# * <i>warnings</i>: (<i>Array</i>) of expected warning messages
# * <i>done</i>:     (<i>Boolean</i>) check for Tabulator DONE state afterwards (optional)
#
# Returns: N/A
#
# Tests the accumulation of a new Counter Count after instantiating the
# Tabulator.  The proper number of <i>errors</i> and <i>warnings</i> should
# appear, and they should match exactly, content-wise.

  def tabulator_test_add_cc(trace, dir, cc_file, errors, warnings, done = false)
    exit(1) unless errors.is_a?(Array) && warnings.is_a?(Array)
    tab = tabulator_test_instantiate_tabulator(trace)
    print "\nTabulator Accumulating New Counter Count from File: #{cc_file}\n"
    cc = tabulator_test_check_syntax(trace, "counter_count", dir, cc_file)
    tab.validate_counter_count(cc)
    tab.update_tabulator_count(cc)
    tabulator_test_write_tabulator_file(tab.tabulator_count)
    taberrs = tabulator_test_errors(tab.validation_errors(), errors)
    tabwarns = tabulator_test_warnings(tab.validation_warnings(), warnings)
    if (tab.validation_errors().length == 0)
      print "Counter Count ACCUMULATED"
    else 
      print "Counter Count REJECTED"
    end
    print " with #{taberrs.to_s} ERRORS and #{tabwarns.to_s} WARNINGS\n"
    tabulator_print_errors_warnings(tab)
    if (done != false)
      doneness = tab.tabulator_state
      if (done == true)
        print "Checking to see if Tabulator State is DONE... "
        assert((doneness[0] =~ /^DONE/) && (doneness[1].length == 0),
               "Tabulator State should be DONE but is not:\n#{doneness[0]}\n")
        print "YES!\n"
      else
        print "Checking the number of missing counts... "
        missing = doneness[1].length
        assert((missing == done),
               "There should be #{done.to_s} missing counts, not #{missing.to_s}")
        print "Counts missing: #{done.to_s}\n"
      end
    end
  end
  
# Arguments:
# * <i>trace</i>:  (<i>Integer</i>) limits tracing of output for the syntax checker
#
# Returns: N/A
#
# Tests the instantiation of a new Tabulator from the contents of the
# <tt><b>TABULATOR_DATA_FILE</b></tt>. There should be no errors or warnings.

  def tabulator_test_instantiate_tabulator(trace)
    tc_file = TABULATOR_DATA_FILE
    print "\nInstantiating Tabulator from File: #{tc_file}\n"
    tc = tabulator_test_check_syntax(trace, "tabulator_count", ".", tc_file)
    tab = Tabulator.new(false, false, false, tc)
    taberrs = tab.validation_errors().length
    assert(0 == taberrs,
           "Expected NO Validation Errors, Received: #{taberrs.to_s}" +
           tabulator_messages_generate(tab.validation_errors(), ERRHEAD))
    tabwarns = tab.validation_warnings().length
    assert(0 == tabwarns,
           "Expected NO Validation Warnings, Received: #{tabwarns.to_s}" +
           tabulator_messages_generate(tab.validation_warnings(), WARHEAD))
    print "Tabulator Successfully Instantiated from File\n"
    tab
  end

# Arguments:
# * <i>file</i>: (<i>String</i>) file name
#
# Returns: N/A
#
# Reads and returns the contents of the <i>file</i>, while testing to ensure
# the file read operation succeeds.

  def tabulator_test_read_file(file, label)
    print "Reading #{label}: #{file}\n"
    assert(schema = File.open(file) { |infile| YAML::load(infile) },
           "Error Reading from #{label} File: #{file}")
    schema
  end

# Arguments:
# * <i>tc</i>: (<i>Hash</i>) Tabulator Count data
#
# Returns: N/A
#
# Writes the Tabulator Count data to the <tt><b>TABULATOR_DATA_FILE</b></tt>, while
# testing to ensure that the file write operation succeeds.

  def tabulator_test_write_tabulator_file(tc)
    file = TABULATOR_DATA_FILE
    print "Writing Tabulator Count: #{file}\n"
    assert(File.open(file, "w") { |outfile| YAML::dump(tc, outfile) },
           "Error Writing to File: #{file}")
  end

end