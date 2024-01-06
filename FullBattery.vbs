set oLocator = CreateObject("WbemScripting.SWbemLocator")
set oShell = CreateObject("Wscript.shell")
set oServices = oLocator.ConnectServer(".", "root\wmi")
set oResults = oServices.ExecQuery("select * from batteryfullchargedcapacity")
for each oResult in oResults
  iFull = oResult.FullChargedCapacity
next

while (1)
  set oResults = oServices.ExecQuery("select * from batterystatus")
  for each oResult in oResults
    iRemaining = oResult.RemainingCapacity
    bCharging = oResult.Charging
  next
  iPercent = ((iRemaining / iFull) * 100) mod 100
  if bCharging and (iPercent > 95) Then oShell.run "powershell -executionpolicy bypass -file .\ToastNotification.ps1", 0, True
  wscript.sleep 300000 ' 5 minutes
wend