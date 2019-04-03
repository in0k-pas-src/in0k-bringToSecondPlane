![Alt text](https://g.gravizo.com/source/custom_activity1124?https%3A%2F%2Fraw.githubusercontent.com%2Fin0k-pas-src%2Fin0k-bringToSecondPlane%2Fblob%2Fmaster%2Ftest.md)
<details> 
<summary>asdasd</summary>
custom_activity1124
@startuml;
(*) --> if "Some Test" then;

  -->[true] "activity 1";

  if "" then;
    -> "activity 3" as a3;
  else;
    if "Other test" then;
      -left-> "activity 5";
    else;
      --> "activity 6";
    endif;
  endif;

else;

  ->[false] "activity 2";

endif;

a3 --> if "last test" then;
  --> "activity 7";
else;
  -> "activity 8";
endif;
@enduml
custom_activity1124  
</details>

dsfgdsfg
