#!/usr/bin/env bash
# Script hỗ trợ deploy dự án GEOFlow trên môi trường Local thông qua Docker Compose

set -e

echo "=========================================="
echo "🚀 Khởi động GEOFlow Local Environment 🚀"
echo "=========================================="

# Di chuyển thư mục làm việc về thư mục gốc của dự án nếu script được gọi từ thư mục deploy-scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# 1. Kiểm tra môi trường Docker và Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ Docker chưa được cài đặt. Vui lòng cài đặt Docker Desktop hoặc Docker Engine trước."
    exit 1
fi

DOCKER_COMPOSE_CMD=""
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
elif docker-compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
else
    echo "❌ Docker Compose chưa được cài đặt (không tìm thấy docker compose hay docker-compose)."
    exit 1
fi

# 2. Tạo file .env nếu chưa có
if [ ! -f ".env" ]; then
    echo "⚙️  File .env không tồn tại. Đang sao chép từ .env.example..."
    cp .env.example .env
    echo "✅ Đã tạo file .env."
else
    echo "✅ File .env đã tồn tại."
fi

# 3. Chạy docker compose
echo "🐳 Đang dọn dẹp các container cũ (để tránh lỗi của docker-compose v1.29)..."
$DOCKER_COMPOSE_CMD rm -fs

echo "🐳 Đang tiến hành build và khởi động các container..."
$DOCKER_COMPOSE_CMD build
$DOCKER_COMPOSE_CMD up -d

echo "=========================================="
echo "🎉 Quá trình khởi động đã hoàn tất! 🎉"
echo ""
echo "Các service có thể mất 1-2 phút để khởi động hoàn toàn (đặc biệt là tiến trình init khởi tạo DB)."
echo "Bạn có thể truy cập dự án tại:"
echo "👉 Trang chủ: http://localhost:18080"
echo "👉 Trang quản trị: http://localhost:18080/geo_admin/login"
echo ""
echo "Tài khoản đăng nhập mặc định:"
echo "👤 Username: admin"
echo "🔑 Password: password"
echo "=========================================="
