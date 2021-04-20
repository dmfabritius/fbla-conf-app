select
 QuestionID,
 case when AnswerChoice='AnswerChoice1' then 1
      when AnswerChoice='AnswerChoice2' then 2
      when AnswerChoice='AnswerChoice3' then 3
      when AnswerChoice='AnswerChoice4' then 4
 end AnswerChoice,
 Answer
from (select QuestionID, AnswerChoice1, AnswerChoice2, AnswerChoice3, AnswerChoice4 from TestQuestions) q
unpivot (Answer for AnswerChoice in (AnswerChoice1, AnswerChoice2, AnswerChoice3, AnswerChoice4)) u;
