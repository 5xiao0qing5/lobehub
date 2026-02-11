import {
  DropdownMenuPopup,
  DropdownMenuPortal,
  DropdownMenuPositioner,
  DropdownMenuRoot,
  DropdownMenuTrigger,
} from '@lobehub/ui';
import { memo, useCallback, useEffect, useState } from 'react';

import { useIsMobile } from '@/hooks/useIsMobile';

import { PanelContent } from './components/PanelContent';
import { styles } from './styles';
import { type ModelSwitchPanelProps } from './types';

const ModelSwitchPanel = memo<ModelSwitchPanelProps>(
  ({
    children,
    model: modelProp,
    onModelChange,
    onOpenChange,
    open,
    placement = 'topLeft',
    provider: providerProp,
  }) => {
    const [internalOpen, setInternalOpen] = useState(false);
    const isMobile = useIsMobile();
    const isOpen = open ?? internalOpen;

    useEffect(() => {
      if (!isMobile || !isOpen || typeof document === 'undefined') return;

      const timer = window.setTimeout(() => {
        const activeElement = document.activeElement;
        if (activeElement instanceof HTMLElement) activeElement.blur();
      }, 0);

      return () => window.clearTimeout(timer);
    }, [isMobile, isOpen]);

    const handleOpenChange = useCallback(
      (nextOpen: boolean) => {
        setInternalOpen(nextOpen);
        onOpenChange?.(nextOpen);
      },
      [onOpenChange],
    );

    return (
      <DropdownMenuRoot open={isOpen} onOpenChange={handleOpenChange}>
        <DropdownMenuTrigger openOnHover>{children}</DropdownMenuTrigger>
        <DropdownMenuPortal>
          <DropdownMenuPositioner hoverTrigger placement={placement}>
            <DropdownMenuPopup className={styles.container}>
              <PanelContent
                model={modelProp}
                provider={providerProp}
                onModelChange={onModelChange}
                onOpenChange={handleOpenChange}
              />
            </DropdownMenuPopup>
          </DropdownMenuPositioner>
        </DropdownMenuPortal>
      </DropdownMenuRoot>
    );
  },
);

ModelSwitchPanel.displayName = 'ModelSwitchPanel';

export default ModelSwitchPanel;

export { type ModelSwitchPanelProps } from './types';
