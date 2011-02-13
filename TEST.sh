#!/bin/bash

exitif () 
{ 
if [ "$?" -gt "0" ] 
then
  exit $?
else
  echo " "
fi
}

test_tab ()
{
    ruby tabulator_test.rb
    exitif
}

test_all ()
{
    test_syntax
    test_tab
    test_default
    test_bedrock
    test_va
    test_dc
    echo -e "\n!! ALL TABULATOR TESTS SUCCESSFUL !!\n"
    exit
}

test_default ()
{
    ruby operator.rb reset
    exitif
    ruby operator.rb load Tests/Default/JD.yml Tests/Default/ED.yml OK
    exitif
    ruby operator.rb add Tests/Default/CC1.yml
    exitif
    ruby operator.rb add Tests/Default/CC2.yml
    exitif
    ruby operator.rb add Tests/Default/CC3.yml
    exitif
}

test_def0 ()
{
    ruby operator.rb reset
    exitif
    ruby operator.rb load Tests/Default/JD.yml Tests/Default/ED.yml OK
    exitif
}

test_def1 ()
{
    ruby operator.rb reset
    exitif
    ruby operator.rb load Tests/Default/JD.yml Tests/Default/ED.yml OK
    exitif
    ruby operator.rb add Tests/Default/CC1.yml
    exitif
}

test_def2 ()
{
    ruby operator.rb reset
    exitif
    ruby operator.rb load Tests/Default/JD.yml Tests/Default/ED.yml OK
    exitif
    ruby operator.rb add Tests/Default/CC1.yml
    exitif
    ruby operator.rb add Tests/Default/CC2.yml
    exitif
}

test_syntax ()
{
    ruby check_syntax_yaml_test.rb
    exitif
}

test_dc ()
{
    ruby operator.rb reset
    exitif
    ruby operator.rb load Tests/DC/DC_EMGR_JD.yml Tests/DC/DC_EMGR_ED.yml OK
    exitif
}

test_va ()
{
    ruby operator.rb reset
    exitif
    ruby operator.rb load Tests/VA/VA_EMGR_JD.yml Tests/VA/VA_EMGR_ED.yml OK
    exitif
}

test_bedrock ()
{
    ruby operator.rb reset
    exitif
    ruby operator.rb load Tests/Bedrock/Bedrock_JD.yml Tests/Bedrock/Bedrock_ED.yml OK
    exitif
    ruby operator.rb add Tests/Bedrock/Bedrock_CC1.yml
    exitif
}

if [ "$#" -eq 0 ]
then 
    test_all
    exit 0
fi
case $1 in
all*)
    test_all
    exit
    ;;
tab*)
    test_tab
    exit
    ;;
def0*)
    test_def0
    exit
    ;;
def1*)
    test_def1
    exit
    ;;
def2*)
    test_def2
    exit
    ;;
def*)
    test_default
    exit
    ;;
syn*)
    test_syntax
    exit
    ;;
dc)
    test_dc
    exit
    ;;
va)
    test_va
    exit
    ;;
bed*)
    test_bedrock
    exit
    ;;
esac
echo Valid arguments are: \<nothing\>, all, syntax, tab, default, bedrock, dc, va
exit 1
