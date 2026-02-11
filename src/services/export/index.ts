import { lambdaClient } from '@/libs/trpc/client';
import { type DataExportType, type ExportDatabaseData } from '@/types/export';

class ExportService {
  exportData = async (exportType: DataExportType = 'all'): Promise<ExportDatabaseData> => {
    return await lambdaClient.exporter.exportData.mutate({ exportType });
  };
}

export const exportService = new ExportService();
