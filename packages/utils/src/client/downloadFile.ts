const triggerLinkDownload = (url: string, fileName?: string) => {
  const link = document.createElement('a');
  link.href = url;
  link.style.display = 'none';
  link.rel = 'noopener noreferrer';

  if (fileName) {
    link.download = fileName;
  }

  document.body.append(link);
  link.click();
  link.remove();
};

export const downloadFile = async (
  url: string,
  fileName: string,
  fallbackToOpen: boolean = true,
) => {
  const parsedUrl = new URL(url, window.location.href);
  const parsedUrlString = parsedUrl.toString();
  const isSameOrigin = parsedUrl.origin === window.location.origin;

  // Cross-origin downloads should use direct navigation instead of fetch.
  // This avoids CORS/credential constraints in self-hosted deployments.
  if (!isSameOrigin) {
    triggerLinkDownload(parsedUrlString);
    return;
  }

  try {
    const response = await fetch(parsedUrlString, {
      cache: 'no-store',
      credentials: 'include',
      mode: 'cors',
    });

    if (!response.ok) {
      throw new Error(`Failed to fetch download file: ${response.status} ${response.statusText}`);
    }

    const contentType = response.headers.get('content-type') || '';
    if (contentType.includes('text/html')) {
      throw new Error('Expected downloadable file, got HTML response instead');
    }

    const blob = await response.blob();
    const blobUrl = window.URL.createObjectURL(blob);

    triggerLinkDownload(blobUrl, fileName);

    window.URL.revokeObjectURL(blobUrl);
  } catch (error) {
    console.log('Download failed:', error);

    if (fallbackToOpen) {
      window.open(parsedUrlString);
    } else {
      throw error;
    }
  }
};
