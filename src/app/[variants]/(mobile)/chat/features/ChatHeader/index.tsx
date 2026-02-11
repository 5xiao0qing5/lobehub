'use client';

import { ActionIcon, Flexbox } from '@lobehub/ui';
import { ChatHeader } from '@lobehub/ui/mobile';
import { MessageSquarePlus } from 'lucide-react';
import { memo, useState } from 'react';

import ShareButton from '@/app/[variants]/(main)/agent/features/Conversation/Header/ShareButton';
import { MOBILE_HEADER_ICON_SIZE } from '@/const/layoutTokens';
import { INBOX_SESSION_ID } from '@/const/session';
import { useQueryRoute } from '@/hooks/useQueryRoute';
import { useSessionStore } from '@/store/session';

import SettingButton from '../../settings/features/SettingButton';
import ChatHeaderTitle from './ChatHeaderTitle';

const MobileHeader = memo(() => {
  const router = useQueryRoute();
  const [open, setOpen] = useState(false);
  const createSession = useSessionStore((s) => s.createSession);

  return (
    <ChatHeader
      showBackButton
      center={<ChatHeaderTitle />}
      right={
        <Flexbox horizontal align={'center'} gap={4}>
          <ActionIcon
            icon={MessageSquarePlus}
            size={MOBILE_HEADER_ICON_SIZE}
            onClick={() => createSession()}
          />
          <SettingButton mobile />
          <ShareButton mobile open={open} setOpen={setOpen} />
        </Flexbox>
      }
      style={{ width: '100%' }}
      onBackClick={() =>
        router.push('/agent', { query: { session: INBOX_SESSION_ID }, replace: true })
      }
    />
  );
});

export default MobileHeader;
