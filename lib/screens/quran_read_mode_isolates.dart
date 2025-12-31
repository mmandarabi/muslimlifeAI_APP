// 🔧 FIX 1: Background isolate functions for database access
// These run in separate isolates to prevent UI thread blocking

/// Parameter class for page data loading (compute requires single parameter)
class _PageDataParams {
  final int pageNum;
  final Size size;
  
  _PageDataParams(this.pageNum, this.size);
}

/// Load page layout in background isolate
Future<List<LayoutLine>> _loadPageLayoutInBackground(int pageNum) async {
  return await MushafLayoutService.getPageLayout(pageNum);
}

/// Load page text in background isolate  
Future<List<String>> _loadPageTextInBackground(int pageNum) async {
  return await MushafWordReconstructionService.getReconstructedPageLines(pageNum);
}

/// Load page coordinate data in background isolate
Future<MushafPageData> _loadPageDataInBackground(_PageDataParams params) async {
  return await MushafCoordinateService().getPageData(params.pageNum, params.size);
}
