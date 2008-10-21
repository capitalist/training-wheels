Feature: File Detection
  In order to run training wheels quickly
  As a Developer
  I wont file detection built in
  
  Scenario: detection
    Given a specific directory
    When training wheels is run
    Then it should detect files based on a glob argument
  
  