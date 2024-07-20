{ linkFarm
, fetchzip
,
}:
linkFarm "zig-packages" [
  {
    name = "1220491e02c1f645f41d46803d6fc039cbeef125a1d106f90a9cc718f6782df28a08";
    path = fetchzip {
      url = "https://www.sqlite.org/2024/sqlite-autoconf-3450000.tar.gz";
      hash = "sha256-0YUoGd7BAyQng1ev7MXJaefqVnWHkBXVc/D2bT21hWs=";
    };
  }
  {
    name = "1220ed7d1e37d1b9e7cbf63e09fe17dc4cc9c6a07a867130c3cae33978cbd8d8da68";
    path = fetchzip {
      url = "https://github.com/cztomsik/fridge/archive/29edd70.tar.gz";
      hash = "sha256-7H6VhVu5kbeW6Iniyx+WIb8cl/PkZvau76ePSsj628c=";
    };
  }
  {
    name = "122032d6c95983590d41ecf5c4c302ca6a986ac44468319d4cde675dee2f612f7444";
    path = fetchzip {
      url = "https://github.com/cztomsik/tokamak/archive/68c80d6.tar.gz";
      hash = "sha256-6RN+jXtMTrXpyRw29uhL1dJKo8L42ROqFP19cnIrm2M=";
    };
  }
]
