require('dotenv').config();
import { ApolloServer, gql } from 'apollo-server';
import { loadTypeSchema } from './utils/schema';
import { verifyToken } from './utils/token';
import { merge } from 'lodash';

const types = ['user'];

export const start = async () => {
  const rootSchema = `
    schema {
      query: Query
      mutation: Mutation
    }
  `;

  const schemaTypes = await Promise.all(types.map(loadTypeSchema));

  const server = new ApolloServer({
    cors: {
      origin: process.env.DOCKER_UI_IP,
      credentials: true,
    },
    typeDefs: [rootSchema, ...schemaTypes],
    resolvers: merge(
      ...types.map(
        type =>
          require(`./types/${type}/${type.replace(/^.+\//, '')}.resolvers`)
            .default
      )
    ),
    context: async ({ req }) => ({
      ...req,
      userId: await verifyToken(req),
    }),
  });

  server
    .listen({ port: 80 })
    .then(({ url }) => {
      console.log(`🚀 Server ready at ${url}`);
    })
    .catch(err => console.error(err));
};
