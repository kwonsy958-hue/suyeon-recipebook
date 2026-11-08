# 🍳 수연의 레시피북

휴대폰과 PC에서 사용하는 개인용 레시피 웹앱입니다. 이메일 로그인, 레시피 추가·수정·삭제, 카테고리·재료 검색, 즐겨찾기, 비공개 사진 업로드, JSON 텍스트 백업을 지원합니다.

## 1. 준비

- Node.js 20 이상 설치
- [Supabase](https://supabase.com/) 가입 후 새 프로젝트 생성
- [Vercel](https://vercel.com/) 가입 (웹 배포용)

## 2. 데이터베이스 생성

Supabase 프로젝트의 **SQL Editor**에서 `supabase.sql` 파일 전체를 실행합니다. 이 SQL은 레시피마다 로그인 사용자만 접근하도록 RLS 정책을 적용하고, 사진 저장소를 비공개로 만듭니다.

Supabase **Authentication → Providers → Email**에서 이메일 인증 설정을 확인하세요. 이메일 확인을 켠 경우 회원가입 후 확인 메일을 열어야 로그인할 수 있습니다. 운영 전에는 SMTP 설정과 이메일 발송 제한도 확인하세요.

## 3. 환경 변수 설정

프로젝트 루트에서 `.env.example`을 `.env`로 복사한 뒤 아래 값을 입력합니다.

```
VITE_SUPABASE_URL=https://프로젝트주소.supabase.co
VITE_SUPABASE_ANON_KEY=Supabase의 publishable 또는 anon 키
```

Supabase의 **Project Settings → API Keys**에서 값을 확인할 수 있습니다. **service_role / secret 키는 절대로 브라우저 환경 변수에 넣지 마세요.**

## 4. 로컬 실행

```bash
npm install
npm run dev
```

화면에 표시되는 로컬 주소로 접속합니다. `npm run build`로 배포 빌드를 확인할 수 있습니다.

## 5. 인터넷에 배포하기

1. 이 프로젝트를 본인 GitHub 저장소에 업로드합니다.
2. Vercel에서 **Add New → Project**로 해당 저장소를 불러옵니다.
3. Framework Preset을 Vite로 선택합니다.
4. Vercel 프로젝트 환경 변수에 위의 `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`를 등록합니다.
5. 배포 후 받은 `https://...vercel.app` 주소를 Supabase **Authentication → URL Configuration**의 Site URL로 설정하고, 필요하면 Redirect URLs에도 추가합니다.
6. 휴대폰과 PC에서 같은 계정으로 로그인하여 사용합니다.

## 보안 및 주의사항

- 로그인한 사람은 자신의 레시피만 볼 수 있도록 데이터베이스 RLS가 설정되어 있습니다. 서로 다른 계정 간 레시피 공유 기능은 없습니다.
- 사진은 비공개 저장소에 업로드되며 1시간 유효한 임시 서명 URL로 표시됩니다. 오래 켜 둔 페이지에서 사진이 보이지 않으면 새로고침하세요.
- 백업 버튼은 **레시피 텍스트 데이터만 JSON으로 저장**하며 실제 사진 파일은 포함하지 않습니다. 사진까지 백업하려면 Supabase Storage를 별도로 백업해야 합니다.
- 계정 분실과 서비스 장애에 대비해 정기적으로 데이터를 백업하세요. 클라우드 저장만으로 영구 보존이 보장되지는 않습니다.
- 사진 교체 시 이전 사진은 레시피 저장에 성공한 후 삭제합니다. 업로드 후 저장 실패 시 고아 사진이 남을 수 있으므로 필요하면 Storage에서 정리하세요.
- 무료 서비스의 제공 조건과 사용량 제한은 변동될 수 있습니다.
