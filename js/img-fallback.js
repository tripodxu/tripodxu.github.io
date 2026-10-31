/* 图片多源回退：jsDelivr -> GitHub raw -> gitmirror
   构建时已把 raw 改写成 jsDelivr（见 scripts/img-mirror.js），
   这里负责在某个源挂掉时按顺序换下一个，最多试 2 次。 */
(function () {
  var MAX_TRIES = 2;

  function parse(u) {
    var m = u.match(/^https?:\/\/cdn\.jsdelivr\.net\/gh\/([^\/]+)\/([^@\/]+)@([^\/]+)\/(.+)$/);
    if (m) return { kind: 'jsdelivr', user: m[1], repo: m[2], branch: m[3], path: m[4] };
    m = u.match(/^https?:\/\/raw\.githubusercontent\.com\/([^\/]+)\/([^\/]+)\/([^\/]+)\/(.+)$/);
    if (m) return { kind: 'raw', user: m[1], repo: m[2], branch: m[3], path: m[4] };
    m = u.match(/^https?:\/\/raw\.gitmirror\.com\/([^\/]+)\/([^\/]+)\/([^\/]+)\/(.+)$/);
    if (m) return { kind: 'gitmirror', user: m[1], repo: m[2], branch: m[3], path: m[4] };
    return null;
  }

  function build(kind, p) {
    var tail = '/' + p.user + '/' + p.repo + '/' + p.branch + '/' + p.path;
    if (kind === 'jsdelivr') return 'https://cdn.jsdelivr.net/gh/' + p.user + '/' + p.repo + '@' + p.branch + '/' + p.path;
    if (kind === 'raw') return 'https://raw.githubusercontent.com' + tail;
    if (kind === 'gitmirror') return 'https://raw.gitmirror.com' + tail;
    return null;
  }

  var ORDER = ['jsdelivr', 'raw', 'gitmirror'];

  window.addEventListener('error', function (e) {
    var img = e.target;
    if (!img || img.tagName !== 'IMG') return;

    // 当前地址要取 src，不能取 data-orig-src：
    // 后者是第一次失败时的原始地址，一直拿它会把回退链卡在前两档来回跳。
    var cur = img.getAttribute('src') || '';
    var p = parse(cur);
    if (!p) return;

    var tries = parseInt(img.getAttribute('data-tries') || '0', 10);
    if (tries >= MAX_TRIES) return;

    if (!img.getAttribute('data-orig-src')) img.setAttribute('data-orig-src', cur);
    img.setAttribute('data-tries', String(tries + 1));

    var idx = ORDER.indexOf(p.kind);
    var next = build(ORDER[idx + 1], p);
    if (next) img.src = next;
  }, true);
})();
