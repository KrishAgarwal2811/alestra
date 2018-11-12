import { CLIENT_OPTIONS, TOKEN } from '../config';
import Alestra from './lib/Alestra';

Alestra.defaultGuildSchema.add('supportChannels', 'TextChannel', { array: true });

new Alestra(CLIENT_OPTIONS).login(TOKEN);