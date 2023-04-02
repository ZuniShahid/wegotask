class TaskHistory {
  TaskHistory(this.createdDate, this.createdTime, this.taskName, this.taskDesc,
      this.userCount, this.status);

  final String createdDate;
  final String createdTime;
  final bool status;
  final String taskDesc;
  final String taskName;
  final int userCount;
}

List<TaskHistory> tempTaskHistory = [
  TaskHistory('22/12/2002', '07:02 am', 'UTLITIES BILLS & FILLING GAS',
      'BILLS & FILLING GAS', 03, true),
  TaskHistory('22/12/2002', '07:02 am', "UTLITIES BILLS & FILLING GAS",
      '& FILLING GAS', 03, false),
  TaskHistory('22/12/2002', '07:02 am', 'UTLITIES BILLS & FILLING GAS',
      'BILLS & FILLING GAS', 03, false),
  TaskHistory(
      '22/12/2002', '07:02 am', 'UTLITIES', 'BILLS & FILLING GAS', 03, false),
  TaskHistory(
      '22/12/2002', '07:02 am', 'UTLITIES', 'BILLS & FILLING GAS', 03, false),
];
