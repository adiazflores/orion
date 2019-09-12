export let solutionQuery = `   
    query($questionId: ID!){
        solution(where: {question_id: {_eq: $questionId}}) {
            solutionId:solution_id
            description
            video
            solutionTemplate:solution_template {
              name
              solutionTemplateId:solution_template_id
            }
            createdAt:created_at
            createdBy:user {
              firstname
              lastname
            }
            lastUpdatedAt:last_updated_at
            lastUpdatedBy:user_last_updated_by {
              firstname
              lastname
            }
        }
    }
`;
