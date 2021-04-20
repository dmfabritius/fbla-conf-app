del d:\data\FCS\fcsdb3.bacpac > d:\data\FCS\backup.log 2>&1
ren d:\data\FCS\fcsdb2.bacpac fcsdb3.bacpac >> d:\data\FCS\backup.log 2>>&1
ren d:\data\FCS\fcsdb1.bacpac fcsdb2.bacpac >> d:\data\FCS\backup.log 2>>&1
ren d:\data\FCS\fcsdb.bacpac  fcsdb1.bacpac >> d:\data\FCS\backup.log 2>>&1
"C:\Program Files (x86)\Microsoft SQL Server\120\DAC\bin\sqlpackage.exe" /a:Export /ssn:"fcs2.cloudapp.net" /sdn:"fcsdb" /su:"xxx" /sp:"xxx" /tf:"d:\data\FCS\fcsdb.bacpac" >> d:\data\FCS\backup.log 2>>&1

