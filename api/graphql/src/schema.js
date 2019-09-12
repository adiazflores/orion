import { gql } from 'apollo-server';

const typeDefs = gql`
  type Query {
    users: [User!]!
  }

  type Mutation {
    signup(
      email: String!
      password: String!
      firstname: String!
      lastname: String!
      username: String!
      roleId: Int!
    ): AuthPayload
    deleteUser(id: Int!, active: Boolean!): User
    signin(email: String!, password: String!): AuthPayload
  }

  scalar Date

  enum Role {
    ADMIN
    STUDENT
    TEACHER
    PARENT
    OTHER
  }

  enum Status {
    DRAFT
    LIVE
    RETIRED
  }

  enum ContentType {
    QUESTION
    PASSAGE
    ANSWER_CHOICE
  }

  enum Subject {
    READING
    MATH
    LANGUAGE_WRITING
    COLLEGE_TRIVIA
    FINANCIAL_LITERACY
  }

  enum QuestionTemplate {
    TEXT_ONLY_QUESTION
    NO_QUESTION
    MATH_QUESTION
    DOUBLE_QUESTION
    OPENING_COPY_IMAGE_QUESTION
    QUESTION_IMAGE
    IMAGE_QUESTION
    STUDENT_PRODUCED_RESPONSE
    XC_TEXT_ONLY
  }

  enum QuestionType {
    SAT
    XC
  }

  enum StudentProducedResponse {
    RANGE
    SINGLE_ANSWER
    MULTIPLE_ANSWER
  }

  enum AnswerTemplate {
    MULTIPLE_CHOICE_TEXT_ONLY
    MULTIPLE_CHOICE_LINE_REFERENCE_LINK
    MULTIPLE_CHOICE_LINKED_LINES
    MULTIPLE_CHOICE_IMAGES
  }

  type AuthPayload {
    token: String
    user: User
    validationMsg: String
  }

  type User {
    userId: ID!
    username: String!
    firstname: String!
    lastname: String!
    email: String!
    password: String!
    role: Int!
    score: Int!
    stats: UserStats!
    avatarUrl: String!
    active: Boolean!
    createdAt: Date!
    lastUpdatedAt: Date
    lastUpdatedBy: User
    createdBy: User
  }

  type Challenge {
    challengeId: ID!
    code: String!
    subject: Subject
    status: Status!
    name: String!
    date: Date
    stats: ChallengeStats
    active: Boolean!
    createdAt: Date!
    lastUpdatedAt: Date
    lastUpdatedBy: User
    createdBy: User!
    surveyUrl: String
  }

  type Passage {
    passageId: ID!
    code: String!
    name: String!
    image: Image
    instructions: String
    description: String!
    source: String
    sourceUrl: String
    subject: Subject
    status: Status!
    active: Boolean!
    createdAt: Date!
    lastUpdatedAt: Date
    lastUpdatedBy: User
    createdBy: User!
  }

  type Image {
    title: String!
    sourceOrAuthor: String
    url: String
  }

  type Tag {
    tagId: ID!
    title: String!
    subject: Subject!
    contentType: ContentType
    active: Boolean!
    createdAt: Date!
    lastUpdatedAt: Date
    lastUpdatedBy: User
    createdBy: User!
  }

  type MultipleQuestion {
    multipleQuestionId: ID!
    question: Question!
    order: Int!
  }

  type Question {
    questionId: ID!
    code: String!
    questionTemplate: QuestionTemplate!
    passage: Passage
    subject: Subject!
    status: Status!
    stats: QuestionStats
    textQuestion: String
    math: String
    openingCopy: String
    image: String
    useCalculator: Boolean
    active: Boolean!
    type: QuestionType!
    createdAt: Date!
    lastUpdatedAt: Date
    lastUpdatedBy: User
    createdBy: User!
  }

  type AnswerChoice {
    answerChoiceId: ID!
    answerTemplate: AnswerTemplate!
    question: Question!
    order: Int
    description: String!
    image: String!
    stats: AnswerStats
    isCorrectAnswer: Boolean!
    studentProducedResponse: StudentProducedResponse
    studentProducedResponseRangeFrom: Float
    studentProducedResponseRangeTo: Float
    studentProducedResponseRingleValue: Float
    createdAt: Date!
    lastUpdatedAt: Date
    lastUpdatedBy: User
    createdBy: User!
    active: Boolean!
  }

  type Solution {
    solutionId: ID!
    text: String!
    question: Question
    solutionTemplate: SolutionTemplate
    description: String!
    video: String
    createdAt: Date!
    lastUpdatedAt: Date
    lastUpdatedBy: User
    createdBy: User!
    active: Boolean!
  }

  type SolutionTemplate {
    solutionTemplateId: ID!
    name: String!
  }

  type PassageMultipleQuestion {
    passageMultipleQuestionId: ID!
    passage: Passage
    multipleQuestion: MultipleQuestion
  }

  #--------------------------------------------
  #               STUDENT APP                 #
  #--------------------------------------------
  type UserStats {
    totalCompleted: Int!
    timeSpent: Int!
    streak: Int!
  }

  type ChallengeStats {
    totalCompleted: Int!
    totalStarted: Int!
    totalTimeSpent: Int!
    nextChallengeClicks: Int!
  }

  type QuestionStats {
    totalCompleted: Int!
    totalSucceed: Int!
    totalTimeSpent: Int!
  }

  type AnswerStats {
    totalClicks: Int!
  }
`;

export default typeDefs;
