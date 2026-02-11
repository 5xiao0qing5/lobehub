'use client';

import { ActionIcon, Flexbox } from '@lobehub/ui';
import { ChatHeader } from '@lobehub/ui/mobile';
import { MessageSquarePlus } from 'lucide-react';
import { memo, useState } from 'react';

import ShareButton from '@/app/[variants]/(main)/agent/features/Conversation/Header/ShareButton';
import { MOBILE_HEADER_ICON_SIZE } from '@/const/layoutTokens';
import { INBOX_SESSION_ID } from '@/const/session';
import { useQueryRoute } from '@/hooks/useQueryRoute';
import { useActionSWR } from '@/libs/swr';
import { useChatStore } from '@/store/chat';

import SettingButton from '../../settings/features/SettingButton';
import ChatHeaderTitle from './ChatHeaderTitle';

const MobileHeader = memo(() => {
  const router = useQueryRoute();
  const [open, setOpen] = useState(false);
  const openNewTopicOrSaveTopic = useChatStore((s) => s.openNewTopicOrSaveTopic);
  const { mutate: handleNewTopic } = useActionSWR(
    'openNewTopicOrSaveTopic',
    openNewTopicOrSaveTopic,
  );

  return (
    <ChatHeader
      showBackButton
      center={<ChatHeaderTitle />}
      style={{ width: '100%' }}
      right={
        <Flexbox horizontal align={'center'} gap={4}>
          <ActionIcon
            icon={MessageSquarePlus}
            size={MOBILE_HEADER_ICON_SIZE}
            onClick={() => handleNewTopic()}
          />
          <SettingButton mobile />
          <ShareButton mobile open={open} setOpen={setOpen} />
        </Flexbox>
      }
      onBackClick={() =>
        router.push('/agent', { query: { session: INBOX_SESSION_ID }, replace: true })
      }
    />
  );
});

export default MobileHeader;
