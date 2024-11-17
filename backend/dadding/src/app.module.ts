import { MiddlewareConsumer, Module } from '@nestjs/common';
import { FirebaseModule } from './firebase/firebase.module';
import { PostModule } from './post/post.module';
import { ConfigModule } from '@nestjs/config';
import { TagModule } from './tag/tag.module';
import { UserModule } from './user/user.module';
import { CommentModule } from './comment/comment.module';
import { ChatGateway } from './chat/chat.gateway';
import { MessageModule } from './message/message.module';
import { ChatRoomModule } from './chat-room/chat-room.module';
import { AuthMiddleware } from './auth.middleware';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    FirebaseModule,
    PostModule,
    TagModule,
    UserModule,
    CommentModule,
    MessageModule,
    ChatRoomModule,
  ],
  controllers: [],
  providers: [ChatGateway],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(AuthMiddleware).forRoutes('*');
  }
}
