<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Date" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cadastro de Pedido</title>
</head>
<body>

<%
    // Receber os dados digitados no formulário
    int id;
    String numero;
    Date inspecao;
    int idc;
    String descricao;

    try {
        // Receber e converter os parâmetros do formulário
        id = Integer.parseInt(request.getParameter("id_pedido"));
        numero = request.getParameter("numero_pedido");
        String dataPedidoStr = request.getParameter("data_pedido");
        inspecao = Date.valueOf(dataPedidoStr);
        idc = Integer.parseInt(request.getParameter("id_cliente"));
        descricao = request.getParameter("status_pedido");

        // Fazer conexão com o banco de dados
        Connection conecta;
        PreparedStatement st;
        ResultSet rs;
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/banco303", "root", "");

        // Verificar se o cliente existe na tabela cliente
        st = conecta.prepareStatement("SELECT COUNT(*) FROM cliente WHERE Id_Cliente = ?");
        st.setInt(1, idc);
        rs = st.executeQuery();
        rs.next();
        int count = rs.getInt(1);

        if (count > 0) {
            // Inserir os dados na tabela pedido do banco de dados
            st = conecta.prepareStatement("INSERT INTO pedido (Id_Pedido, Numero_Pedido, Data_Pedido, Id_Cliente, Status_Pedido) VALUES (?, ?, ?, ?, ?)");
            st.setInt(1, id);
            st.setString(2, numero);
            st.setDate(3, inspecao);
            st.setInt(4, idc);
            st.setString(5, descricao);

            st.executeUpdate(); // Executa o comando insert

            out.print("Pedido cadastrado com sucesso!");
        } else {
            out.print("Erro: O cliente com ID " + idc + " não existe.");
        }

        // Fechar a conexão
        rs.close();
        st.close();
        conecta.close();
    } catch (ClassNotFoundException e) {
        out.print("Erro ao carregar o driver JDBC: " + e.getMessage());
    } catch (SQLException e) {
        out.print("Erro de SQL: " + e.getMessage());
    } catch (NumberFormatException e) {
        out.print("Erro de formato de número: " + e.getMessage());
    } catch (IllegalArgumentException e) {
        out.print("Erro de formato de data: " + e.getMessage());
    } catch (Exception e) {
        out.print("Erro: " + e.getMessage());
    }
%>

</body>
</html>
