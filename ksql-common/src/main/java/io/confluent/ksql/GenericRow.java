/*
 * Copyright 2018 Confluent Inc.
 *
 * Licensed under the Confluent Community License (the "License"); you may not use
 * this file except in compliance with the License.  You may obtain a copy of the
 * License at
 *
 * http://www.confluent.io/confluent-community-license
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OF ANY KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations under the License.
 */

package io.confluent.ksql;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class GenericRow {

  private final ArrayList<Object> columns;

  public GenericRow() {
    this(0);
  }

  public GenericRow(final int initialCapacity) {
    this.columns = new ArrayList<>(initialCapacity);
  }

  public GenericRow(final List<Object> columns) {
    Objects.requireNonNull(columns);
    this.columns = new ArrayList<>(columns);
  }

  public static GenericRow genericRow(final Object... columns) {
    return new GenericRow(Arrays.asList(columns));
  }

  /**
   * Ensure the row has enough capacity to hold {@code additionalCapacity} more elements
   * that its current size.
   *
   * <p>Useful to avoid unnecessary array copies when adding multiple elements.
   *
   * @param additionalCapacity the number of additional elements
   */
  public void ensureAdditionalCapacity(final int additionalCapacity) {
    columns.ensureCapacity(additionalCapacity + columns.size());
  }

  @Override
  public String toString() {
    final StringBuilder stringBuilder = new StringBuilder("[ ");
    int currentIndex = 0;
    for (int i = 0; i < columns.size(); i++) {
      final Object obj = columns.get(i);
      if (obj == null) {
        stringBuilder.append("null");
      } else if (obj.getClass().isArray()) {
        stringBuilder.append(Arrays.toString((Object[]) obj));
      } else if (obj instanceof String) {
        stringBuilder.append("'")
            .append(obj)
            .append("'");
      } else {
        stringBuilder.append(obj);
      }

      currentIndex++;
      if (currentIndex < columns.size()) {
        stringBuilder.append(" | ");
      }
    }
    stringBuilder.append(" ]");
    return stringBuilder.toString();
  }

  @Override
  public boolean equals(final Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    final GenericRow that = (GenericRow) o;
    if (columns.size() != that.columns.size()) {
      return false;
    }

    // For now string matching is used to compare the rows as double comparison will cause issues
    return this.toString().equals(that.toString());
  }

  @Override
  public int hashCode() {
    return Objects.hash(columns);
  }

  public List<Object> getColumns() {
    return columns;
  }

  @SuppressWarnings("unchecked")
  public <T> T getColumnValue(final int columnIndex) {
    return (T) columns.get(columnIndex);
  }
}
