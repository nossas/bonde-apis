import bcrypt from 'bcryptjs';
import { JWT } from '../types';
import { generateJWT } from '../utils';
import * as UsersAPI from '../graphql-api/users';
import * as InvitationsAPI from '../graphql-api/invitations';
import * as NotificationsAPI from '../graphql-api/notifications';

type RegisterInput = {
  email: string
  first_name: string
  last_name?: string
  password: string
  code: string
}

type RegisterArgs = {
  input: RegisterInput
}

export default async (root: void, args: RegisterArgs): Promise<JWT> => {
  const { input: { email, first_name, last_name, password, code } } = args;

  // Validate fields
  if (password.length < 6) throw new Error('password_lt_six_chars');
  if ((await UsersAPI.find({ email })).length > 0) throw new Error('email_already_exists');

  const values = {
    uid: email,
    provider: 'email',
    email,
    first_name,
    last_name,
    admin: true,
    encrypted_password: await bcrypt.hash(password, 9),
    community_users: {}
  };

  const invite = await InvitationsAPI.find({ code, email });
  values.community_users = { data: { role: invite.role, community_id: invite.community.id } };

  // Create user and generate token
  const user = await UsersAPI.insert(values);

  // Become invite invlid
  await InvitationsAPI.done(invite.id);

  // Send welcome_user e-mail
  const context = { community: invite.community, user: { first_name: user.first_name } };
  await NotificationsAPI.send(
    { email_to: user.email, email_from: 'suporte@bonde.org', context },
    { locale: 'pt-br', label: 'welcome_user' }
  );

  // Return token to login user after register
  return { first_name: user.first_name, valid: true, token: generateJWT(user) };
};



/**
  * TODO:
  * mutation register (input: RegisterInput): JWT
  * - [ ] Só pode ser acessado por um usuário não autenticado. role: anonymous
  * - [X] Preenchimento obrigatório de "first_name", "email", "password"
  * - [X] Validação para "password" > 6 caracteres
  * - [X] Criar usuário com "password" criptografado no banco de dados
  * - [X] Verificar "invite_code" para fazer relação com comunidade convidada
  * - [X] Todos os usuários são criados por padrão com role: common_user
  * - [X] Enviar e-mail com modelo de template "welcome_user" para usuário criado
  */