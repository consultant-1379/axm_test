package com.ericsson.axm.test.operators;

public interface TrussCollectionOperator {

  /**
   * Get the process ID for truss
   */
   String findTrussProcessId();

  /**
   * Collects truss log from server
   */
  void startTrussLogCollection();

  /**
   * Kill the Truss Process
   */
  boolean trussProcessKill();

}
