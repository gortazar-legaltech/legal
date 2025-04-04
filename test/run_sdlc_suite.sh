#!/bin/bash
set -o pipefail  # ⚠️ Mejor que set -e para no cortar flujo por errores menores

SCRIPT_DIR="$(cd "$(BASE_DIR="$(dirname "$0")/..")" && pwd)"
cd "$SCRIPT_DIR"

LOG="sdlc_full_log.txt"
JSON="sdlc_report.json"
MD="sdlc_report.md"

echo "🔍 Iniciando SDLC Suite para GORTÁZAR LegalTech" | tee $LOG
echo "Fecha: $(date)" | tee -a $LOG
echo "==============================================" | tee -a $LOG

declare -A ERRORS
TOTAL_ERRORS=0

run_test() {
  NAME=$1
  SCRIPT=$2
  echo "" | tee -a $LOG
  echo "🧪 Test: $NAME" | tee -a $LOG
  echo "----------------------------------" | tee -a $LOG

  if [ ! -f "$SCRIPT" ]; then
    echo "❌ Script no encontrado: $SCRIPT" | tee -a $LOG
    ERRORS[$NAME]=1
    TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
    return
  fi

  if [ ! -x "$SCRIPT" ]; then
    chmod +x "$SCRIPT"
  fi

  OUTPUT=$("./$SCRIPT" 2>&1) || {
    echo "❌ Error al ejecutar $SCRIPT" | tee -a $LOG
  }

  echo "$OUTPUT" | tee -a $LOG
  COUNT=$(echo "$OUTPUT" | grep -c "❌")
  ERRORS[$NAME]=$COUNT
  TOTAL_ERRORS=$((TOTAL_ERRORS + COUNT))
}

# Ejecutar tests
run_test "Assets" test_assets_sdlc.sh
run_test "Layouts" test_layouts_sdlc.sh
run_test "Components" test_components_sdlc.sh
run_test "Pages" test_pages_sdlc.sh
run_test "Styles" test_styles_sdlc.sh

# Resumen final
echo "" | tee -a $LOG
echo "🧾 Resumen SDLC Final" | tee -a $LOG
echo "----------------------" | tee -a $LOG
for key in "${!ERRORS[@]}"; do
  echo "🔸 $key: ${ERRORS[$key]} error(es)" | tee -a $LOG
done
echo "✅ Total de errores detectados: $TOTAL_ERRORS" | tee -a $LOG

# Recomendaciones IA
echo "" | tee -a $LOG
echo "💡 Recomendaciones para el developer (IA Hints)" | tee -a $LOG
[ "${ERRORS[Assets]}" -gt 0 ] && echo "- Revisa nombres, formatos y ubicación de tus assets" | tee -a $LOG
[ "${ERRORS[Layouts]}" -gt 0 ] && echo "- Verifica que todos los layouts estén conectados con <slot /> y sean usados" | tee -a $LOG
[ "${ERRORS[Components]}" -gt 0 ] && echo "- Usa y referencia correctamente los components desde layouts o páginas" | tee -a $LOG
[ "${ERRORS[Pages]}" -gt 0 ] && echo "- Asegura estructura semántica, import de layout y accesibilidad (<h1>)" | tee -a $LOG
[ "${ERRORS[Styles]}" -gt 0 ] && echo "- Centraliza estilos en global.css y evita inline style" | tee -a $LOG
echo "- Todos los errores están listos para revisión y mejora guiada." | tee -a $LOG

# Exportar JSON
echo "{" > $JSON
for key in "${!ERRORS[@]}"; do
  echo "  \"$key\": ${ERRORS[$key]}," >> $JSON
done
echo "  \"Total\": $TOTAL_ERRORS" >> $JSON
echo "}" >> $JSON

# Exportar Markdown
echo "# 📋 Informe SDLC GORTÁZAR LegalTech" > $MD
echo "Fecha: $(date)" >> $MD
echo "" >> $MD
for key in "${!ERRORS[@]}"; do
  echo "- **$key**: ${ERRORS[$key]} error(es)" >> $MD
done
echo "" >> $MD
echo "**Total**: $TOTAL_ERRORS errores**" >> $MD
echo "" >> $MD
echo "## 💡 Recomendaciones IA" >> $MD
[ "${ERRORS[Assets]}" -gt 0 ] && echo "- Revisa nombres, formatos y ubicación de tus assets" >> $MD
[ "${ERRORS[Layouts]}" -gt 0 ] && echo "- Verifica que todos los layouts estén conectados con <slot /> y sean usados" >> $MD
[ "${ERRORS[Components]}" -gt 0 ] && echo "- Usa y referencia correctamente los components desde layouts o páginas" >> $MD
[ "${ERRORS[Pages]}" -gt 0 ] && echo "- Asegura estructura semántica, import de layout y accesibilidad (<h1>)" >> $MD
[ "${ERRORS[Styles]}" -gt 0 ] && echo "- Centraliza estilos en global.css y evita inline style" >> $MD

# Salida con código de error si falló algo
if [ "$TOTAL_ERRORS" -gt 0 ]; then
  exit 1
fi

echo "✅ Script maestro SDLC ejecutado con éxito. Ver logs y reportes en: $LOG, $JSON, $MD"
