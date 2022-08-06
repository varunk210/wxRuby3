#--------------------------------------------------------------------
# @file    gdicommon.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  class Director

    class GDICommon < Director

      def setup(spec)
        spec.ignore %w{
          wxStockCursor.wxCURSOR_BASED_ARROW_DOWN
          wxStockCursor.wxCURSOR_BASED_ARROW_UP
          wxStockCursor.wxCURSOR_CROSS_REVERSE
          wxStockCursor.wxCURSOR_DOUBLE_ARROW
          wxTheColourDatabase
        }
        spec.ignore [
          'wxClientDisplayRect(int *,int *,int *,int *)',
          'wxDisplaySize(int *,int *)',
          'wxDisplaySizeMM(int *,int *)',
          'wxRect::Inflate(wxCoord,wxCoord) const',
          'wxRect::Deflate(wxCoord,wxCoord) const',
          'wxRect::Intersect(const wxRect &) const',
          'wxRect::Union(const wxRect &) const'
        ]
        spec.add_extend_code 'wxPoint', <<~__HEREDOC
          wxPoint add(const wxSize &sz) {
            return *$self + sz;
          }
          wxPoint add(const wxPoint &pt) {
            return *$self + pt;
          }
          wxPoint sub(const wxSize &sz) {
            return *$self - sz;
          }
          wxPoint sub(const wxPoint &pt) {
            return *$self - pt;
          }
          wxSize div(int factor) {
            return *$self / factor;
          }
          wxSize mul(int factor) {
            return *$self * factor;
          }
          bool eql(const wxPoint &pt) {
            return *$self == pt;
          }
        __HEREDOC
        spec.add_extend_code 'wxRealPoint', <<~__HEREDOC
          wxRealPoint add(const wxSize &sz) {
            return *$self + sz;
          }
          wxRealPoint add(const wxRealPoint &pt) {
            return *$self + pt;
          }
          wxRealPoint sub(const wxSize &sz) {
            return *$self - sz;
          }
          wxRealPoint sub(const wxRealPoint &pt) {
            return *$self - pt;
          }
          wxSize div(int factor) {
            return *$self / factor;
          }
          wxSize mul(int factor) {
            return *$self * factor;
          }
          bool eql(const wxRealPoint &pt) {
            return *$self == pt;
          }
        __HEREDOC
        spec.add_extend_code 'wxRect', <<~__HEREDOC
          wxRect add(const wxRect &r) {
            return *$self + r;
          }
          wxRect mul(const wxRect &r) {
            return *$self * r;
          }
          bool eql(const wxRect &r) {
            return *$self == r;
          }
        __HEREDOC
        spec.add_extend_code 'wxSize', <<~__HEREDOC
          wxSize add(const wxSize &sz) {
            return *$self + sz;
          }
          wxSize sub(const wxSize &sz) {
            return *$self - sz;
          }
          wxSize div(int factor) {
            return *$self / factor;
          }
          wxSize div(double factor) {
            return *$self / factor;
          }
          wxSize mul(int factor) {
            return *$self * factor;
          }
          wxSize mul(double factor) {
            return *$self * factor;
          }
          bool eql(const wxSize &pt) {
            return *$self == pt;
          }
        __HEREDOC

        super
      end

      def process(spec)
        defmod = super
        e = defmod.find('wxBitmapType')
        e.items.each do |item|
          item.ignore if item.name.end_with?('_RESOURCE')
        end
        defmod
      end
    end # class GDICommon

  end # class Director

end # module WXRuby3