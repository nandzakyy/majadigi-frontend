FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

ARG API_BASE_URL=
RUN flutter build web --release --dart-define=API_BASE_URL=${API_BASE_URL}

FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

# Create JavaScript rewrite script for localhost API URL fix
RUN cat > /usr/share/nginx/html/fix_localhost.js << 'EOF'
(function(){
  if (!location.host || !location.host.endsWith('andikanugra.my.id')) return;
  const map = { 'http://localhost:3000':'https://api.andikanugra.my.id' };
  function rewrite(url){
    try{ if(typeof url==='string'){ Object.keys(map).forEach(k=>{ if(url.indexOf(k)===0) url = url.replace(k,map[k]); }); } }
    catch(e){}
    return url;
  }
  const _fetch = window.fetch;
  window.fetch = function(resource, init){
    try{
      if(typeof resource === 'string') resource = rewrite(resource);
      else if(resource && resource.url){ let newUrl = rewrite(resource.url); resource = new Request(newUrl, resource); }
    }catch(e){}
    return _fetch.call(this, resource, init);
  };
  const XHROpen = XMLHttpRequest.prototype.open;
  XMLHttpRequest.prototype.open = function(method,url){
    try{ if(typeof url === 'string') url = rewrite(url); }catch(e){}
    return XHROpen.apply(this, arguments);
  };
  const origOpen = window.open;
  window.open = function(url, name, specs){
    try{ if(typeof url === 'string') url = rewrite(url); }catch(e){}
    return origOpen.call(this, url, name, specs);
  };
  const origAssign = window.location.assign;
  window.location.assign = function(url){
    try{ if(typeof url === 'string') url = rewrite(url); }catch(e){}
    return origAssign.call(this, url);
  };
  const origReplace = window.location.replace;
  window.location.replace = function(url){
    try{ if(typeof url === 'string') url = rewrite(url); }catch(e){}
    return origReplace.call(this, url);
  };
})();
EOF

# Inject the fix_localhost.js script into index.html before closing body tag
RUN sed -i 's|</body>|<script src="/fix_localhost.js"><\/script>\n</body>|g' /usr/share/nginx/html/index.html

EXPOSE 80
